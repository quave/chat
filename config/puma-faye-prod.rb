#!/usr/bin/env puma

# start puma with:
# RAILS_ENV=production bundle exec puma -C ./config/puma.rb

workers ENV['FAYE_WORK'].to_i || 0
application_path = '/var/www/chat'
railsenv = 'production'
rackup 'faye.ru'
environment railsenv
daemonize true
pidfile "#{application_path}/tmp/pids/puma-faye-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-faye-#{railsenv}.state"
stdout_redirect "#{application_path}/log/puma-faye-#{railsenv}.stdout.log", "#{application_path}/log/puma-faye-#{railsenv}.stderr.log"
threads 4, 16
bind "unix:///var/tmp/chat-faye.sock"

preload_app!