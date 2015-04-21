server 'xxxx.example.com',
  user: 'hubot',
  roles: %w[app web db],
  ssh_options: {
    keys: [File.expand_path('~/.ssh/id_hubot')],
    port: 12022,
    forward_agent: true,
    auth_methods: %w(publickey)
  }

set :branch, ENV['BRANCH'] || "master"