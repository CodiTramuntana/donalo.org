web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: QUEUES=default,paperclip,mailers bundle exec rake jobs:work
release: bundle exec rake db:structure:load
