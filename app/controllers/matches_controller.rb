require "json"
require 'uri'
require 'net/http'
require 'openssl'

class MatchesController < ApplicationController
  API_KEY = ENV['SPORTS_RADAR_API_KEY']
  URL = "https://api.sportradar.com/tennis/trial/v3/en"
  ENDPOINT = ".json?api_key=#{API_KEY}"

  def index
    @matches = Match.all
  end

  def show

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

  def define_versus(player1, player2)
    url = URI("https://api.sportradar.com/tennis/trial/v3/en/competitors/#{player1}/versus/#{player2}/summaries.json?api_key=#{API_KEY}")

    return search_for_data(url)
  end
end
