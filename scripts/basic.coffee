# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
exec = require('child_process').exec
fs   = require('fs')

exec = require('child_process').exec
fs   = require('fs')

module.exports = (robot) ->
  robot.respond /version|info|rev|revision|ver/i, (msg) ->
    version = "Oh shit! 自分のバージョンが分からないネー！"
    exec 'hostname; git log --oneline | wc -l ; git branch --contains ;', (err, stdout, stderr) ->
      stdout_ar = stdout.split(/\n/)
      system_info =  {
        hostname:  stdout_ar[0].replace(/^(.+?)\..+/,"$1").toUpperCase(),
        commits:  stdout_ar[1].match(/[0-9]+?$/),
        branch:  stdout_ar[2],
      }

      version =  "KONGO AUTOMATED RESPONSE MODULE [ALPHA] : "

      if !err
        cmd_log = stdout.split(/\n/)
        switch true
          when /develop/.test system_info.branch
            mode = "EXPERIMENTAL"
          when /master/.test system_info.branch
            mode = "RELEASE CANDIDATE"
          else
            mode = "RETAIL ENGINE"

        version += mode
        version += " "

        if system_info.commits == 0
          cap_revision = fs.readFileSync("#{__dirname}/../REVISION", "utf-8")
          if cap_revision
            version += " NO."
            version += cap_revision.replace(/\n/,"").toUpperCase()
        else
          version += "REV." + system_info.commits

        version += " " + "(RUNNING ON \"#{system_info.hostname}\")"

      else
        cmd_log = stderr.split(/\n/)
        version += "RETAIL ENGINE"

        cap_revision = fs.readFileSync("#{__dirname}/../REVISION", "utf-8")
        if cap_revision
          version += " REV."
          version += cap_revision.replace(/\n/,"").toUpperCase()
          version += " "
          version += "(RUNNING ON \"#{system_info.hostname}\")"

      msg.send version
  #
  # robot.topic (msg) ->
  #   msg.send "#{msg.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (msg) ->
  #   msg.send msg.random enterReplies
  # robot.leave (msg) ->
  #   msg.send msg.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (msg) ->
  #   unless answer?
  #     msg.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   msg.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (msg) ->
  #   setTimeout () ->
  #     msg.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (msg) ->
  #   if annoyIntervalId
  #     msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   msg.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (msg) ->
  #   if annoyIntervalId
  #     msg.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     msg.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, msg) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if msg?
  #     msg.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (msg) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     msg.reply "I'm too fizzy.."
  #
  #   else
  #     msg.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (msg) ->
  #   robot.brain.set 'totalSodas', 0
  #   robot.respond 'zzzzz'
