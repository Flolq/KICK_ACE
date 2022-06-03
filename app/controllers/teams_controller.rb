class TeamsController < ApplicationController
  before_action :my_secured_selections, only: [:starting, :submitted, :extra_round]
  before_action :defining_remaining_players, only: [:starting, :submitted, :extra_round]


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
    @teams_non_submitted = @league.teams.where("progress = 'starting'")
    @teams_submitted = @league.teams.where("progress = 'bids_submitted'")

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
      format.html # Follow regular flow of Rails
      format.text { render partial: 'teams/list', locals: { players: @players }, formats: [:html] }
    end

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

    @team.selections.each do |selection|
      selection.progress = "bid_submitted"
    end
    @teams_non_submitted = @league.teams.select{ |team| team.progress != "bids_submitted" }
    @teams_submitted = @league.teams.select{ |team| team.progress == "bids_submitted" }

    results

    @team.save

  end

  def extra_round
    @team = Team.find(params[:id])
    @team.progress = "bidding"
    @league = @team.league
    @players_selected = []
    @selections_already_secured = Selection.where("progress = ?", "bid_won")

    @selections_already_secured.each do |selection|
      @players_selected << selection.player
    end


    @remaining_players = []
    @players = Player.all
    @players.each do |player|
      unless @players_selected.include?(player)
        @remaining_players << player
      end
    end
    @team.save
  end



  def show
    @team = Team.find(params[:id])
    @selections = @team.selections.sort_by { |player| player[:position] }
  end

  private

  def team_params
    params
      .require(:team)
      .permit(:name, selections_attributes: [:player_id, :price])
  end

  def results
    selections = @league.selections
    selections = selections.group_by { |selection| selection.player_id }
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
      if selection.progress = "bid_won"
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
end
