require 'faker'
require "json"
require 'uri'
require 'open-uri'
require 'net/http'
require 'openssl'
require 'date'

puts "To start, let's destroy the db"

Selection.destroy_all
Team.destroy_all
Chatroom.destroy_all
League.destroy_all
User.destroy_all
# ranking = 1
i = 0

puts 'We want the players'

API_KEY = ENV['SPORTS_RADAR_API_KEY']
URL = "https://api.sportradar.com/tennis/trial/v3/en"
ENDPOINT = ".json?api_key=#{API_KEY}"

def search_for_data(url)
  url = URI(url)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)

  response = http.request(request)
  return JSON.parse(response.read_body)
end

if Player.count.zero?
  def create_players(players)
    players.each do |player|
      points = player["points"]
      name = player["competitor"]["name"].split(", ")

      Player.create!(
        first_name: name.last,
        last_name: name.first,
        ranking: player["rank"],
        atp_points: points,
        min_price: points * 5000,
        nationality: player["competitor"]["country"],
        atpid: player["competitor"]["id"]
      )
    end

    Player.create!(
      first_name: "Ranked",
      last_name: "Non",
      ranking: 501,
      atp_points: 0,
      min_price: 0,
      nationality: "Unknown",
      atpid: "unknown"
    )
  end

  def update_players(players)
    players.each do |player|
      points = player["points"]

      target_player = Player.find_by(atpid: player["competitor"]["id"])

      target_player.update(
        ranking: player["rank"],
        atp_points: points,
        min_price: points * 5000
      )
    end
  end

  def add_infos_to_player(player_id, player_atpid)
    player_detail_url = "#{URL}/competitors/#{player_atpid}/profile#{ENDPOINT}"
    data = search_for_data(player_detail_url)
    sleep 1

    date_array = data["info"]["date_of_birth"].split("-")
    birthdate = Date.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)

    player = Player.find(player_id)
    player.date_of_birth = birthdate
    player.competitions_played = data["periods"].first["statistics"]["competitions_played"]
    player.competitions_won = data["periods"].first["statistics"]["competitions_won"]
    player.matches_played = data["periods"].first["statistics"]["matches_played"]
    player.matches_won = data["periods"].first["statistics"]["matches_won"]

    player.save!
  end

  player_rankings_url = "#{URL}/rankings#{ENDPOINT}"
  data = search_for_data(player_rankings_url)
  sleep 1
  players = data["rankings"][0]["competitor_rankings"]

  if Player.count.zero?
    create_players(players)
  else
    update_players(players)
  end

  Player.all.first(100).each do |tennisplayer|
    add_infos_to_player(tennisplayer.id, tennisplayer.atpid)
  end

  puts 'We have our players !!!!'
end

if Tournament.count.zero?
  puts 'Has someone said tournaments? Ok ok, do not move ...'

  def create_tournaments(tournaments)
    tournaments.each do |tournament|
      if tournament["level"]
        Tournament.create(
          name: tournament["name"],
          level: tournament["level"]
        )
      end
    end
  end

  tournaments_url = "#{URL}/competitions#{ENDPOINT}"
  data = search_for_data(tournaments_url)
  sleep 1
  create_tournaments(data["competitions"])

  puts 'Done ;)'
end


if Match.count.zero?
  puts "The first round of matches ..."

  def create_matches(matches)
    matches.each do |match|
      level = match["sport_event"]["sport_event_context"]["competition"]["level"]
      name = match["sport_event"]["sport_event_context"]["competition"]["name"]
      if name == "French Open Men Singles" || level == "atp_1000"
        Match.create!(
          date: match["sport_event"]["start_time"],
          round: match["sport_event"]["sport_event_context"]["round"],
          player1: Player.find_by(atpid: match["sport_event"]["competitors"].first["id"]) || Player.find_by(atpid: "unknown"),
          player2: Player.find_by(atpid: match["sport_event"]["competitors"].last["id"]) || Player.find_by(atpid: "unknown"),
          tournament: Tournament.find_by(name: match["sport_event"]["sport_event_context"]["competition"]["name"]),
          winner: Player.find_by(atpid: match["sport_event_status"]["winner_id"]) || Player.find_by(atpid: "unknown"),
          done: true
        )
      end
    end
  end


  dates = []
  (4..5).to_a.each do |month|
    (1..30).to_a.each do |day|
      dates << "2022-#{'0' + month.to_s}-#{day.to_s.chars.size == 1 ? '0' + day.to_s : day}"
    end
  end
  dates << "2022-05-31"
  dates << "2022-06-01"

  dates.each do |date|
    matches_url = "#{URL}/schedules/#{date}/summaries#{ENDPOINT}"
    data = search_for_data(matches_url)
    create_matches(data["summaries"])
    sleep 1

    matches_url = "#{URL}/schedules/#{date}/summaries#{ENDPOINT}&start=200"
    data = search_for_data(matches_url)
    create_matches(data["summaries"])
    sleep 1

    matches_url = "#{URL}/schedules/#{date}/summaries#{ENDPOINT}&start=400"
    data = search_for_data(matches_url)
    create_matches(data["summaries"])
    sleep 1
  end

  puts "Aaaaaand it's done"
end

puts 'We want the users ...'

User.create!(
  email: "zizou@kick.ace",
  password: 'password',
  nickname: "Zizou",
)
5.times do
  User.create!(
    email: Faker::Internet.email,
    password: 'password',
    nickname: Faker::Sports::Basketball.player,
  )
end

puts 'Yeaaaaahhh, 6 great men ready to play'

puts 'Let\'s have fun, with a new league with its chatroom'

clay_league_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674085/pehup7q6ixsfs5leccrn.jpg")
grass_league_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674147/qfssc7nahaqlquit1czh.jpg")
grey_league_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674169/nab6cjh0c1lysyue1iho.jpg")
hard_league_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674192/qug44xflwqxgmvwazvir.jpg")
hard_blue_league_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674207/yixcppbqr6tz0qwl2e1z.jpg")

LEAGUE_PICS = [
  clay_league_photo,
  grass_league_photo,
  grey_league_photo,
  hard_league_photo,
  hard_blue_league_photo
]

league = League.new(
  name: 'The champions League',
  number_of_users: 6,
  user_id: User.first.id
)

league_photo = LEAGUE_PICS.sample
league.photo.attach(io: league_photo, filename: 'team_logo.jpg', content_type: 'image/jpg')
league.save!

chatroom = Chatroom.new
chatroom.league = league
chatroom.save

puts 'Your league is created, congrats guys'

puts 'Now, build up your team !!!!'

6.times do
  default_team_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654592216/m5mgvwp8xxgk5tnuxxnh.png")
  sheep_team_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673483/qhy1nedxjpxku4n923jp.jpg")
  tiger_team_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673549/zbqzzyuagbgrkwwxw1qy.jpg")
  unicorn_team_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673566/a7lwqa6tdcnzpsrearub.jpg")
  bear_team_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673581/e1a1of847zzg1lbwycgg.jpg")
  croco_team_photo = URI.open("https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673605/zj1pydk3lu6wdy1yxodm.jpg")

  team_pics = [
    default_team_photo,
    sheep_team_photo,
    tiger_team_photo,
    unicorn_team_photo,
    bear_team_photo,
    croco_team_photo
  ]

  team = Team.new(
    name: Faker::Sports::Football.team,
    user_id: User.first.id + i,
    points: rand(100..300),
    league: League.first
  )
  team_photo = team_pics.sample
  team.photo.attach(io: team_photo, filename: 'team_logo.jpg', content_type: 'image/jpg')
  team.save!
  i += 1
end

puts 'Ok, teams are ready!!'

puts 'Almost there, we need our selections now'
i = 0
6.times do
  position = 1
  8.times do
    Selection.create!(
      price: rand(1..30),
      team_id: Team.first.id + i,
      player_id: Player.first(50).sample.id,
      position: position
    )
    position += 1
  end
  i += 1
end

puts 'Les jeux sont faits. All teams completeded'
