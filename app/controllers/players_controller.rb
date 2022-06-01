require "json"
require 'uri'
require 'net/http'
require 'openssl'

class PlayersController < ApplicationController
  API_KEY = ENV['SPORTS_RADAR_API_KEY']
  URL = "https://api.sportradar.com/tennis/trial/v3/en"
  ENDPOINT = ".json?api_key=#{API_KEY}"

  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
    @match = Match.find("player1_id ILIKE ? OR player2_id ILIKE ?", @player.id)
  end
end
