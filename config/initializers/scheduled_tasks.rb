scheduler = Rufus::Scheduler.new

scheduler.cron("0 12 * * *") do
   puts "Check and Send Emails on Today.Date == Round.round_start"
end 
