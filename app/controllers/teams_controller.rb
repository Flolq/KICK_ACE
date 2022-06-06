class TeamsController < ApplicationController
  before_action :my_secured_selections, only: [:starting, :submitted, :final]
  before_action :defining_remaining_players, only: [:starting, :submitted, :final]

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

  def new
    @league = League.find(params[:league_id])
    @team = Team.new
  end

  def create
    @league = League.find(params[:league_id])
    @team = Team.new(team_params)
    @team.league = @league
    @team.user = current_user
    @team.progress = "starting"
    @team.budget = 500

    if @team.save
      redirect_to starting_path(@league, @team)
    else
      render :new
    end
  end

  def starting
    @team = Team.find(params[:id])
    @league = @team.league
  end

  def edit
  end

  def update
    @team = Team.find(params[:id])
    @league = League.find(params[:league_id])
    redirect_to edit_league_team_path(@league, @team)
  end

  def submitted
    @team = Team.find(params[:id])
    @league = @team.league

    @team.progress = "bids_submitted"

    @kept_selections = []
    all_selections = @team.selections.group_by { |selection| selection.player_id }

    all_selections.each do |player_id, player_selections|
      players_selections = player_selections.sort_by { |selection| selection.updated_at }.reverse
      players_selections[0].progress = "bid_submitted"
      @kept_selections << players_selections[0]
    end

    @teams_non_submitted = @league.teams.select{ |team| team.progress != "bids_submitted" }
    @teams_submitted = @league.teams.select{ |team| team.progress == "bids_submitted" }

    if @teams_non_submitted.empty?
      results
      if @current_user_won_results.length == 8
        @team.progress = "finalized"
        redirect_to final_path(@league, @team)
      end
    end

    @teams_non_finalized = @league.teams.select{ |team| team.progress != "finalized" }
    @teams_finalized = @league.teams.select{ |team| team.progress == "finalized" }

    @team.save

  end

  def final
    @team = Team.find(params[:id])
    @league = @team.league
    @teams_non_finalized = @league.teams.select{ |team| team.progress != "finalized" }
    @teams_finalized = @league.teams.select{ |team| team.progress == "finalized" }

  end




  # def extra_round
  #   @team = Team.find(params[:id])
  #   @team.progress = "bidding"
  #   @league = @team.league
  #   @players_selected = []
  #   @selections_already_secured = Selection.where("progress = ?", "bid_won")

  #   @selections_already_secured.each do |selection|
  #     @players_selected << selection.player
  #   end

  #   @remaining_players = []
  #   @players = Player.all
  #   @players.each do |player|
  #     unless @players_selected.include?(player)
  #       @remaining_players << player
  #     end
  #   end
  #   @team.save
  # end

  def show
    @team = Team.find(params[:id])
    @selections = @team.selections.order(:position)
    @selections.each do |selection|
      player = selection.player
      matches = Match.where(player1: player).or(Match.where(player2: player)).order(date: :desc)
      points = player_points(matches, player)
      selection.player_points = points
      selection.save!
    end
  end

  private

  def team_params
    params
      .require(:team)
      .permit(:name, selections_attributes: [:player_id, :price])
  end

  def results
    league_selections = @league.selections
    submitted_selections = []
    league_selections.each do |selection|
      submitted_selections << selection if selection.progress == "bid_submitted"
    end

    selections = league_selections.group_by { |selection| selection.player_id }
    @results = []
    @current_user_won_results = []
    @opponents_won_results = []

    @starting_budget = 500
    @budget_spent = 0

    selections.each do |player_id, player_selections|
      players_selections = player_selections.sort_by { |selection| selection.price }.reverse

      winning_selection = players_selections.shift()
      winning_selection.progress = "bid_won"
      winning_selection.save

      losing_selections = players_selections
      losing_selections.each do |selection|
        selection.progress = "bid_lost"
        selection.save
      end

      winning_user = User.joins(:teams).where("user_id = ?", winning_selection.team.user_id)[0]
      @results << { player_id: player_id, winning_user: winning_user, winning_team: winning_selection.team, winning_selection: winning_selection, losing_selections: losing_selections }
      if current_user == winning_user
        @current_user_won_results << { player_id: player_id, winning_user: winning_user, winning_team: winning_selection.team, winning_selection: winning_selection, losing_selections: losing_selections }
        @budget_spent += winning_selection.price
      else
        @opponents_won_results << { player_id: player_id, winning_user: winning_user, winning_team: winning_selection.team, winning_selection: winning_selection, losing_selections: losing_selections }
      end
      @players_selected << player_id
    end

    @remaining_budget = @starting_budget - @budget_spent
    @team.budget = @remaining_budget

  end

  def my_secured_selections
    @team = Team.find(params[:id])
    @league = @team.league
    @my_secured_selections = @team.selections.where("progress = ?", "bid_won")
  end

  def defining_remaining_players
    @remaining_players = []
    @players_selected = []
    @players = Player.all
    selections = @league.selections
    won_selections = []
    selections.each do |selection|
      if selection.progress == "bid_won"
        won_selections << selection
      end
    end

    won_selections.each do |selection|
      @players_selected << selection.player
    end

    @players.each do |player|
      unless @players_selected.include?(player)
        @remaining_players << player
      end
    end
  end

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
