require "json"
require 'uri'
require 'net/http'
require 'openssl'

class PlayersController < ApplicationController
  API_KEY = ENV['SPORTS_RADAR_API_KEY']
  URL = "https://api.sportradar.com/tennis/trial/v3/en"
  ENDPOINT = ".json?api_key=#{API_KEY}"

  def index
    player_rankings_url = "#{URL}/rankings#{ENDPOINT}"
    data = search_for_data(player_rankings_url)
    @players = data["rankings"][0]["competitor_rankings"]
  end

  def show
    player_id = "sr:competitor:#{params[:id]}"
    player_detail_url = "#{URL}/competitors/#{player_id}/profile#{ENDPOINT}"
    @player = search_for_data(player_detail_url)
    sleep 1
    player_matches_url = "#{URL}/competitors/#{player_id}/summaries#{ENDPOINT}"
    @match = search_for_data(player_matches_url)
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
end
