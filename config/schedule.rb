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
set :output, "log/cron.log"
env :PATH, ENV['PATH']
#
every 1.month do
	# command "echo 'you can use raw cron syntax too'"
 #  # command "/usr/bin/some_great_command"
  # runner "product_expired_notifications"
  rake "bill:monthly"
  # rake "bill:half"
end
every 2.month do
	# command "echo 'you can use raw cron syntax too'"
 #  # command "/usr/bin/some_great_command"
  # runner "product_expired_notifications"
  rake "bill:half_semester"
  # rake "bill:half"
end
every :day, at: '12:00am' do
	# command "echo 'you can use raw cron syntax too'"
 #  # command "/usr/bin/some_great_command"
  # runner "product_expired_notifications"
  rake "bill:starting_penalty_fee"
  rake "bill:daily_penalty_fee"
  # rake "bill:half"
end


