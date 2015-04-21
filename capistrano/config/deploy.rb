lock '3.4.0'
set :application, 'tearoom_hubot'
set :repo_url, 'git@github.com:Kaminogi-Works/tearoom_hubot.git'
set :deploy_to, '/home/hubot/tearoom'
# User
set :user, 'hubot'

# Default value for default_env is {}
set :node_env, (fetch(:node_env) || fetch(:stage))
set :default_env, { node_env: fetch(:node_env) }
set :linked_dirs, %w{node_modules/iconv}

# Default value for keep_releases is 5
set :keep_releases, 5
set :pid_file_name, 'tearoom_hubot.pid'
set :pid_file, "/home/#{fetch(:user)}/.forever/pids/#{fetch(:pid_file_name)}"
set :scm, :git
set :git_strategy, Capistrano::Git::SubmoduleStrategy

namespace :deploy do
  desc 'Install node modules non-globally'
  task :npm_install do
    on roles(:app) do
      execute "cd #{release_path} && npm install --production"
    end
  end

  desc 'Install all dependencies'
  task :install_all do
    on roles(:app) do
      invoke 'deploy:npm_install'
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app) do
      within current_path do
        execute :forever, 'start', '-c', 'coffee',"--pidFile", fetch(:pid_file), "node_modules/.bin/hubot", "--adapter slack --name 'hubot'"
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      within current_path do
        execute :forever, 'stopall'
        #execute :forever, 'stop', "node_modules/.bin/hubot"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do

      within current_path do
        info fetch(:pid_file)
        if test "[ -e #{fetch(:pid_file)} ]"
          info "pid found"
          execute :forever, 'stopall'
          execute :forever, 'start','-c', 'coffee',"--pidFile", fetch(:pid_file), "node_modules/.bin/hubot", "--adapter slack --name 'hubot'"
        else
          info "pid not found"
          execute :forever, 'start','-c', 'coffee',"--pidFile", fetch(:pid_file), "node_modules/.bin/hubot", "--adapter slack --name 'hubot'"
        end
      end
    end
  end

  after :publishing, 'deploy:install_all'
  after 'deploy:install_all', 'deploy:restart'
end