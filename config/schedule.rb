# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# every 1.day, at: '03:41pm' do
#   rake 'publish:complete_publish', environment: 'production'
# end
#set :output, "#{Rails.root}/log/cron.log"




# every 1.day, at: '12:00 pm' do
#   rake "publish:complete_publish"
# end


# # schedule.rb

# # Use the 'every' method to define a cron job
# every 1.day, at: '12:40pm' do
#   runner "puts 'Hello'"
# end
#require File.expand_path("config/environment", __dir__)
require "rails"
require "whenever"


every 1.day, at: '12:00 pm' do
  rake "publish:complete_publish", output: { standard: "#{Rails.root}/log/cron_publish.log" }, environment: 'development'
end

every 1.day, at: '14:33 pm' do
  runner "puts 'Hello'", output: { standard: "#{Rails.root}/log/cron_hello.log" }, environment: 'development'
end
