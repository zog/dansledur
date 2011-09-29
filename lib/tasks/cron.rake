desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.seconds % 10 == 0 # run every four hours
    Medium.fetch.from_twitter
  end

end