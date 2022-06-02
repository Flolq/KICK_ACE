require "json"
require 'uri'
require 'net/http'
require 'openssl'

class UpdateMatchJob < ApplicationJob
  queue_as :fetch_api_for_matches

  API_KEY = ENV['SPORTS_RADAR_API_KEY']
  URL = "https://api.sportradar.com/tennis/trial/v3/en"
  ENDPOINT = ".json?api_key=#{API_KEY}"

  def perform
    tournaments_url = "#{URL}/competitions#{ENDPOINT}"
    data = search_for_data(tournaments_url)
    sleep 1
    create_tournaments(data["competitions"])

    today = Time.now.strftime("%Y-%m-%d")
    today_matches_url = "#{URL}/schedules/#{today}/summaries#{ENDPOINT}&start=400"
    data = search_for_data(today_matches_url)
    create_matches(data["summaries"])
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

  def create_matches(matches)
    matches.each do |match|

      level = match["sport_event"]["sport_event_context"]["competition"]["level"]
      if level == "grand_slam" || level == "atp_1000"
        Match.create!(
          date: match["sport_event"]["start_time"],
          round: match["sport_event"]["sport_event_context"]["round"],
          player1: Player.find_by(atpid: match["sport_event"]["sport_event_context"]["competitors"][0]["id"]),
          player2: Player.find_by(atpid: match["sport_event"]["sport_event_context"]["competitors"][1]["id"]),
          tournament: Tournament.find_by(name: match["sport_event"]["sport_event_context"]["competition"]["name"])
        )
      end
    end
  end
end
