class TeamsController < ApplicationController
  before_action :secured_selections, only: [:submitted, :results, :final]
  before_action :defining_remaining_players, only: [:submitted, :results, :final]

  GRAND_SLAM_ROUND_POINTS = {
    round_of_128: 50,
    round_of_64: 60,
    round_of_32: 80,
    round_of_16: 200,
    quarterfinal: 500,
    semifinal: 1000,
    final: 2500
  }

  BONUS_MULTIPLICATOR = {
    pos1: 10,
    pos2: 8,
    pos3: 6,
    pos4: 4,
    pos5: 2,
    pos6: 1
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
    @league.save

    if @team.save
      redirect_to bidding_path(@league, @team)
    else
      render :new
    end
  end

  def bidding
    @team = Team.find(params[:id])
    @league = @team.league

    search_players

    if @team.progress == "bids_submitted"
      if @league.round_progress != "auctions_closed"
        auctions
        @league.round_progress = "auctions_closed"
      end
      updating_budget
    end

    secured_selections
    defining_remaining_players

    if @current_user_secured_selections.length >= 8
      @team.progress = "finalized"
      @team.save

      defining_finalized_teams

      defining_submitted_teams

      progressing_league_round_progress

      redirect_to final_path(@league, @team)
      return
    end

    @team.progress = "bidding"
    @team.save
  end

  def recap

  end

  def submitted
    @team = Team.find(params[:id])
    @league = @team.league

    @team.progress = "bids_submitted"

    filtering_selections

    @team.save

    defining_submitted_teams

    defining_finalized_teams

    progressing_league_round_progress

    @league.save

    render :recap


  end

  def final
    @team.progress = "finalized"
    @team.save
    defining_finalized_teams

    defining_submitted_teams

  end


  def show
    @team = Team.find(params[:id])
    @selections = @team.selections.order(:position)
    @selections.each do |selection|
      player = selection.player
      matches = Match.where(player1: player).or(Match.where(player2: player)).order(date: :desc)
      if selection.player_points == 0
        points = player_points(matches, player)
        selection.player_points = points * BONUS_MULTIPLICATOR["pos#{selection.position}".to_sym]
        selection.save!
      elsif selection.updated_at < matches.first.date
        points = add_player_points(match.first.date, player)
        selection.player_points = points * BONUS_MULTIPLICATOR["pos#{selection.position}".to_sym]
        selection.save!
      end
    end
  end

  private

  def team_params
    params
      .require(:team)
      .permit(:name, :photo, selections_attributes: [:player_id, :price])
  end

  def secured_selections
    @team = Team.find(params[:id])
    @league = @team.league
    @current_user_secured_selections = []
    @opponents_secured_selections = []
    @league.selections.each do |selection|
      if selection.progress == "bid_won"
        if current_user == User.joins(:teams).where("user_id = ?", selection.team.user_id)[0]
          @current_user_secured_selections << selection
        else
          @opponents_secured_selections << selection
        end
      end
    end
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
    points = 0

    matches.each do |match|
      if match.winner == player
        points += ((player.ranking - (player == match.player1 ? match.player2.ranking : match.player1.ranking)) + 100) * 8
        if match.round.split("\"")[3] == "final" && match.tournament.level == "atp_1000"
          points += 2000
        elsif match.round.split("\"")[3] == "final" && match.tournament.level == "grand_slam"
          points += 5000
        end
      elsif match.tournament.level == "atp_1000"
        points += ATP_1000_ROUND_POINTS[match.round.split("\"")[3].to_sym]
      else
        points += GRAND_SLAM_ROUND_POINTS[match.round.split("\"")[3].to_sym]
      end
    end

    return points
  end

  def add_player_points(match, player)
    points = 0

    if match.winner == player
      points += ((player.ranking - (player == match.player1 ? match.player2.ranking : match.player1.ranking)) + 100) * 8
      if match.round.split("\"")[3] == "final" && match.tournament.level == "atp_1000"
        points += 2000
      elsif match.round.split("\"")[3] == "final" && match.tournament.level == "grand_slam"
        points += 5000
      end
    elsif match.tournament.level == "atp_1000"
      points += ATP_1000_ROUND_POINTS[match.round.split("\"")[3].to_sym]
    else
      points += GRAND_SLAM_ROUND_POINTS[match.round.split("\"")[3].to_sym]
    end

    return points
  end

  def auctions
    league_selections = @league.selections
    submitted_selections = []
    league_selections.each do |selection|
      submitted_selections << selection if selection.progress == "bid_submitted"
    end
    selections = submitted_selections.group_by { |selection| selection.player_id }

    @results = []
    @current_user_won_results = []
    @opponents_won_results = []

    @starting_budget = @team.budget
    @budget_spent = 0

    selections.each do |player_id, player_selections|

      if player_selections.length == 1
        winning_selection = player_selections[0]
        winning_selection.progress = "bid_won"
        winning_selection.save
      else

      player_selections = player_selections.sort_by { |selection| selection.price }.reverse

      if (player_selections[0].price == player_selections[1].price) && (player_selections[0].updated_at > player_selections[1].updated_at)
        player_selections[0], player_selections[1] = player_selections[1], player_selections[0]
      end
        winning_selection = player_selections.shift()
        losing_selections = player_selections

        winning_selection.progress = "bid_won"
        winning_selection.save

        losing_selections = player_selections
        losing_selections.each do |selection|
          selection.progress = "bid_lost"
          selection.save
        end
      end
    end
    @team.save

  end

  def search_players
    if params[:query].present?
      sql_query = " \
      players.first_name @@ :query \
      OR players.last_name @@ :query \
    "
      @players = Player.where(sql_query, query: "%#{params[:query]}%")
    else
      @players = Player.all
    end
    respond_to do |format|
      format.html
      format.text { render partial: 'teams/list', locals: { players: @players }, formats: [:html] }
    end
  end

  def updating_budget
    starting_budget = @team.budget
    budget_spent = 0
    @team.selections.each do |selection|
      if selection.progress == "bid_won"
        budget_spent += selection.price
      end
    end
    @team.budget = starting_budget - budget_spent
    @team.save
  end

  def defining_finalized_teams
    @teams_non_finalized = @league.teams.select{ |team| team.progress != "finalized" }
    @teams_finalized = @league.teams.select{ |team| team.progress == "finalized" }
  end

  def defining_submitted_teams
    @teams_submitted = @league.teams.select{ |team| team.progress == "bids_submitted" }
    @teams_non_submitted = @league.teams.select{ |team|  team.progress != "bids_submitted" }
  end

  def progressing_league_round_progress
    @league.round_progress = "bidding_submitted" if @teams_submitted.length == @league.number_of_users
    @league.round_progress = "finalized" if @teams_finalized.length == @league.number_of_users
    @league.save
  end

  def filtering_selections
    filtered_selections = []
    @kept_selections = []

    all_selections = @team.selections

    if @league.round_progress == "bidding_submitted"
      filtered_selections = all_selections
    else
      all_selections.each do |selection|
        unless selection.progress == "bid_won" || selection.progress == "bid_lost"
          filtered_selections << selection
        end
      end
    end

    grouped_selections = filtered_selections.group_by { |selection| selection.player_id }
    grouped_selections.each do |_player_id, player_selections|
      players_selections = player_selections.sort_by { |selection| selection.updated_at }.reverse
      players_selections[0].progress = "bid_submitted"
      players_selections[0].save
      @kept_selections << players_selections[0]
    end
  end
end
