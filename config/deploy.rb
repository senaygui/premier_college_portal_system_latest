# config valid for current version and patch releases of Capistrano
# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

set :application, "premiernew"
# set :ssh_options, { :forward_agent => true }
set :repo_url, "https://github.com/senaygui/premier_college_portal_system_latest.git"

set :git_http_username, 'senygui' 
ask(:github_token, "github_token", echo: false) 
set :git_http_password, fetch((:github_token))

# set :user, "deploy"
set :passenger_restart_with_touch, true
# set :rbenv_path, '/home/deploy/.rbenv/'
# set :deploy_to, "/home/deploy/yic_production"
set :stages, %w(production staging)
# append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

set :keep_releases, 10
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# set :git_ssh_command, "ssh -o ForwardAgent=yes"


# set :ssh_options, { keys:['/home/deploy/.ssh/id_rsa'] }
#

# :forward_agent => true, 
#    auth_methods:['publickey'],
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure




