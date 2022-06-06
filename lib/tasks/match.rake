namespace :match do
  desc "Updating yesterday matches"
  task update_all: :environment do
    puts "Added yesterday matches"
    UpdateMatchJob.perform_later
  end
end
