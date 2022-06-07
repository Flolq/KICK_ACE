require "csv"

filepath = "./lib/assets/cloudinary.csv"

CSV.open(filepath, "wb") do |csv|
  csv << ["last name", "url"]
  Player.all.first(50).each do |player|
    last_name = player.last_name.downcase.gsub(" ", "-")
    buffer_array = [last_name]

    cloudinary_hash = Cloudinary::Uploader.upload("app/assets/images/players/#{last_name}.png")
    if cloudinary_hash.nil?
      url = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654592216/m5mgvwp8xxgk5tnuxxnh.png"
    else
      url = cloudinary_hash["secure_url"]
    end
    buffer_array << url
    csv << buffer_array
  end
end
