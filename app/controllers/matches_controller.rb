class MatchesController < ApplicationController
  API_KEY = ENV['SPORTS_RADAR_API_KEY']

  def show
    match_detail_url = "https://api.sportradar.com/tennis/trial/v3/en/sport_events/#{params[:id]}/summary.json?api_key=#{API_KEY}"
    @match = JSON.parse(URI.open(match_detail_url).read)
    players = @match["sport_event"]["competitors"]
    versus_detail_url = "https://api.sportradar.com/tennis/trial/v3/en/competitors/#{players[0]['id']}/versus/#{players[1]['id']}/summaries.json?api_key=#{API_KEY}"
    @versus = JSON.parse(URI.open(versus_detail_url).read)
    @key = API_KEY
  end
end
