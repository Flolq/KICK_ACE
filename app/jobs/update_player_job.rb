require "json"
require 'uri'
require 'net/http'
require 'openssl'

class UpdatePlayerJob < ApplicationJob
  queue_as :fetch_api_for_players

  API_KEY = ENV['SPORTS_RADAR_API_KEY']
  URL = "https://api.sportradar.com/tennis/trial/v3/en"
  ENDPOINT = ".json?api_key=#{API_KEY}"

  def perform
    player_rankings_url = "#{URL}/rankings#{ENDPOINT}"
    data = search_for_data(player_rankings_url)
    sleep 1
    players = data["rankings"][0]["competitor_rankings"]
    create_players(players)
  end

  private

  def search_for_data(url)
    url = URI(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    return JSON.parse(response.read_body)
  end

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
  end
end
