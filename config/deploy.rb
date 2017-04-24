# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "think_qa"
set :repo_url, "git@github.com:Fatpaher/think_qa.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/think_qa"
set :deploy_user, 'deploy'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", '.env'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'public/uploads'

set :default_shell, '/bin/bash -l'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
