class TeamController < ApplicationController
  # def new
  #   @team = Team.new
  # end

  # def create
  #   @league = League.find(params[:league_id])
  #   @team = Team.new(team_params)
  #   @team.league = @league
  #   if @team.save
  #     redirect_to league_path(@league)
  #   else
  #     render :new
  #   end
  # end

  # def edit
  #   @team = Team.find(params[:id])
  # end

  # def update
  #   @team = Team.find(params[:id])
  #   @team.update(team_params)

  #   redirect_to team_path(@team)
  # end

  def show
    @team = team.find(params[:team_id])
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
