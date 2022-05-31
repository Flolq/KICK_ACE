require "json"
require "open-uri"

class PlayersController < ApplicationController
  API_KEY = ENV['SPORTS_RADAR_API_KEY']
  URL = "https://api.sportradar.com/tennis/trial/v3/en/rankings.json?api_key=#{API_KEY}"

  def index
    data = JSON.parse(URI.open(URL).read)
    @players = data["rankings"][0]["competitor_rankings"]
  end

  def show
    player_detail_url = "https://api.sportradar.com/tennis/trial/v3/en/competitors/#{params[:id]}/profile.json?api_key=#{API_KEY}"
    @player = JSON.parse(URI.open(player_detail_url).read)
    player_match_url = "https://api.sportradar.com/tennis/trial/v3/en/competitors/#{params[:id]}/summaries.json?api_key=#{API_KEY}"
    @match = JSON.parse(URI.open(player_match_url).read)
  end
end
