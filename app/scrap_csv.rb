require 'open-uri'
require "csv"

filepath = "./lib/assets/cloudinary.csv"

CSV.foreach(filepath, headers: :first_row) do |row|
  last_name = row['last name'].gsub("-", " ")
  player = Player.find_by("last_name ILIKE ? OR last_name ILIKE ?", last_name, row['last name'])
  player_photo = URI.open(row['url'])
  player.photo.attach(io: player_photo, filename: 'player.png', content_type: 'image/png')
end
