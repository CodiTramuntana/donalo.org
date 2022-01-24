# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "donalo"
set :repo_url, "git@github.com:CodiTramuntana/donalo.org.git"

set :rbenv_type, :user # or :system, or :fullstaq (for Fullstaq Ruby), depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RAILS_ENV=#{fetch(:stage)} RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

append :linked_files, 'config/config.yml', 'config/puma.rb'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'node_modules', 'storage'

namespace :puma do
  desc 'Stop puma'
  task :stop do
    on roles(:all) do
      file_pid = "#{fetch(:deploy_to)}/shared/tmp/pids/server.pid"
      execute "if [ -f #{file_pid} ] && [ -s #{file_pid} ] && [ -d /proc/$(cat #{file_pid}) ]
      then kill -9 $(cat #{file_pid})
      fi"
    end
  end
  
  desc 'Start puma'
  task :start do
    on roles(:all) do
      within release_path do
        execute :bundle, "exec puma -d"
      end
    end
  end
end

after 'deploy', 'puma:stop'
after 'deploy', 'puma:start'
