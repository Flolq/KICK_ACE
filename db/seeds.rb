require 'faker'

puts "To start, let's destroy the db"


Selection.destroy_all
Player.destroy_all
Team.destroy_all
League.destroy_all
User.destroy_all
ranking = 1
i = 0
player = 0

puts 'We want the players'

50.times do
  Player.create!(
    first_name: Faker::Sports::Football.player,
    last_name: '!',
    ranking: ranking,
    min_price: rand(1..30),
    nationality: Faker::Nation.nationality,
  )
  ranking += 1
end

puts 'We have our players !!!!'

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

puts 'Let\'s have fun, with a new league'

League.create!(
  name: 'The champions League',
  number_of_users: 6,
  user_id: User.first.id,
)

puts 'Your league is created, congrats guys'

puts 'Now, build up your team !!!!'

6.times do
  Team.create!(
    name: Faker::Sports::Football.team,
    user_id: User.first.id + i,
    points: rand(100..300),
    league: League.first,
  )
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
      player_id: Player.first.id + player,
      position: position,
    )
    player += 1
    position += 1
  end
  i += 1
end

puts 'Les jeux sont faits. All teams completeded'
