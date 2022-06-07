require "json"
require 'uri'
require 'net/http'
require 'openssl'

class PlayersController < ApplicationController
  GRAND_SLAM_ROUND_POINTS = {
    round_of_128: 50,
    round_of_64: 60,
    round_of_32: 80,
    round_of_16: 200,
    quarterfinal: 500,
    semifinal: 1000,
    final: 2500
  }

  ATP_1000_ROUND_POINTS = {
    round_of_32: 60,
    round_of_16: 80,
    quarterfinal: 250,
    semifinal: 500,
    final: 1000
  }

  def index
    @players = Player.all.first(50)
  end

  def show
    @player = Player.find(params[:id])
    @matches = Match.where(player1: @player).or(Match.where(player2: @player)).order(date: :desc)
    @points = player_points(@matches, @player)
  end

  private

  def player_points(matches, player)
    buffer = ""
    points = 0

    matches.each do |match|
      if buffer == match.tournament.name
        points += 0
      elsif match.winner == player
        points += ((player.ranking - (player == match.player1 ? match.player2.ranking : match.player1.ranking)) + 100) * 8
      elsif match.tournament.level == "atp_1000"
        points += ATP_1000_ROUND_POINTS[match.round.split("\"")[3].to_sym]
      else
        points += GRAND_SLAM_ROUND_POINTS[match.round.split("\"")[3].to_sym]
      end

      buffer = match.tournament.name
    end

    return points
  end
end
