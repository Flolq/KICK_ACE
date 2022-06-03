class LeaguesController < ApplicationController

  def index
    @leagues = League.all
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    @league.owner = current_user
    if @league.save
      redirect_to edit_league_path(@league)
    else
      render :new
    end
  end

  def show
    @league = League.find(params[:id])
    @teams = @league.teams.sort_by { |element| -element[:points] }
    @team = Team.where(["league_id = ? and user_id = ?", params[:id], current_user.id]).first
    @selections = @team.selections.sort_by { |player| player[:position] }
  end

  def edit
    @league = League.find(params[:id])
    @teams = @league.teams
  end


  def update
    @league = League.find(params[:id])
    @league.update(league_params)

    redirect_to edit_league_path(@league)
  end


  private

  def league_params
    params.require(:league).permit(:name, :number_of_users)
  end
end
