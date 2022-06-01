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
    @players = Player.all
  end

  def update
    @team = Team.find(params[:id])
    @league = League.find(params[:league_id])

    progress_team

    @team.update(team_params)
    raise

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
