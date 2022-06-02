class TeamsController < ApplicationController
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

    if @team.save
      redirect_to edit_league_team_path(@league, @team)
    else
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
    @league = League.find(params[:league_id])
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

    if @teams_non_submitted.empty?

    end
  end

  def update
    @team = Team.find(params[:id])
    progress_team
    @team.save
    @league = League.find(params[:league_id])
    redirect_to edit_league_team_path(@league, @team)
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

  def progress_team
    if @team.progress == "starting"
      @team.progress = "bids_submitted"
    end
  end
end
