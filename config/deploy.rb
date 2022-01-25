# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "donalo"
set :repo_url, "git@github.com:CodiTramuntana/donalo.org.git"

set :rbenv_type, :user # or :system, or :fullstaq (for Fullstaq Ruby), depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RAILS_ENV=#{fetch(:stage)} RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_service_unit_name, "#{fetch(:application)}.puma.service"

append :linked_files, 'config/application.yml', 'config/puma.rb'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'node_modules', 'storage'

namespace :npm do
  desc 'Install node modules'
  task :install do
    on roles(:app) do
      within release_path do
        execute :npm, 'install'
      end
    end
  end
end
after 'bundler:install', 'npm:install'

namespace :delayed_job do
  desc 'Start the delayed_job process'
  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, 'donalo.delayed_job.service'
    end
  end
  desc 'Stop the delayed_job process'
  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, 'donalo.delayed_job.service'
    end
  end
  desc 'Restart the delayed_job process'
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, 'donalo.delayed_job.service'
    end
  end
end
after 'deploy:finished', 'delayed_job:restart'

namespace :sphinx do
  desc 'Start the sphinx process'
  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, 'donalo.sphinx.service'
    end
  end

  desc 'Stop the sphinx process'
  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, 'donalo.sphinx.service'
    end
  end

  desc 'Restart the sphinx process'
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, 'donalo.sphinx.service'
    end
  end
end
after 'deploy:finished', 'sphinx:restart'
