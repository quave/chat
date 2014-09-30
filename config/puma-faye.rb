#!/usr/bin/env puma

# start puma with:
# RAILS_ENV=production bundle exec puma -C ./config/puma.rb

application_path = '.'
railsenv = 'development'
rackup 'faye.ru'
environment railsenv
daemonize false
pidfile "#{application_path}/tmp/pids/puma-faye-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-faye-#{railsenv}.state"
threads 0, 16
bind 'tcp://0.0.0.0:9292'