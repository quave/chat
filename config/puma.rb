#!/usr/bin/env puma

# start puma with:
# RAILS_ENV=production bundle exec puma -C ./config/puma.rb

workers ENV['SITE_WORK'].to_i || 0
application_path = '/var/www/chat'
railsenv = 'production'
directory application_path
environment railsenv
daemonize true
pidfile "#{application_path}/tmp/pids/puma-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-#{railsenv}.state"
stdout_redirect "#{application_path}/log/puma-#{railsenv}.stdout.log", "#{application_path}/log/puma-#{railsenv}.stderr.log"
threads 4, 16
bind "unix:///var/tmp/chat.sock"

preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end