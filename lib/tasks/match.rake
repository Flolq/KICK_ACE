namespace :match do
  desc "Updating players infos and matches"
  task update_all: :environment do
    puts "Destroy all matches and tournaments from database"
    Match.destroy_all
    Tournament.destroy_all

    puts "Get TOP100 players in ATP ranking"
    UpdateMatchJob.perform_later
  end
end
