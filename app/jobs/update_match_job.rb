require "json"
require 'uri'
require 'net/http'
require 'openssl'
require 'date'

class UpdateMatchJob < ApplicationJob
  queue_as :fetch_api_for_matches

  API_KEY = ENV['SPORTS_RADAR_API_KEY']
  URL = "https://api.sportradar.com/tennis/trial/v3/en"
  ENDPOINT = ".json?api_key=#{API_KEY}"

  def perform
    date = Date.yesterday
    date_to_s = "#{date.year}-#{date.month.to_s.size == 1 ? '0' + date.month.to_s : date.month.to_s}-#{date.day.to_s.size == 1 ? '0' + date.day.to_s : date.day.to_s}"

    matches_url = "#{URL}/schedules/#{date_to_s}/summaries#{ENDPOINT}"
    data = search_for_data(matches_url)
    create_matches(data["summaries"])
    sleep 2

    matches_url = "#{URL}/schedules/#{date_to_s}/summaries#{ENDPOINT}&start=200"
    data = search_for_data(matches_url)
    create_matches(data["summaries"])
    sleep 2

    matches_url = "#{URL}/schedules/#{date_to_s}/summaries#{ENDPOINT}&start=400"
    data = search_for_data(matches_url)
    create_matches(data["summaries"])
    sleep 2
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
end
