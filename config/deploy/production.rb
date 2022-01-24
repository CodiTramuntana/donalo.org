# frozen_string_literal: true

server '207.154.245.34', user: 'codit', roles: %w{app db web}
set :stage, 'production'
set :branch, 'production'
set :deploy_to, '/var/www/donalo'
