class TeamsController < ApplicationController
  def new
    @league = League.find(params[:league_id])
    @team = Team.new
    3.times { @team.selections.build }
  end

  def create
    @league = League.find(params[:league_id])
    @team = Team.new(team_params)
    @team.league = @league
    @team.user = current_user

    @team.selections.each do |selection|
      selection.progress = "bid_submitted"
    end

    if @team.save
      redirect_to [@league, @team]
    else
      render :new
    end
  end

  # def edit
  #   @team = Team.find(params[:id])
  # end

  # def update
  #   @team = Team.find(params[:id])
  #   @team.update(team_params)

  #   redirect_to team_path(@team)
  # end

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
end
