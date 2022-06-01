namespace :player do
  desc "Updating players infos and matches"
  task update_all: :environment do
    puts "Destroy all players from database"
    Match.destroy_all
    Player.destroy_all

    puts "Get TOP100 players in ATP ranking"
    UpdatePlayerJob.perform_later
  end
end
