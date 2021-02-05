workers ENV.fetch("WEB_CONCURRENCY") { 2 } unless Gem.win_platform?
threads_count = ENV.fetch("MAX_THREADS") { 5 }
threads threads_count, threads_count

rackup      DefaultRackup
port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

preload_app!

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end