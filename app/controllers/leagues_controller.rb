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
      @chatroom = Chatroom.new
      @chatroom.league = @league
      @chatroom.save
      redirect_to edit_league_path(@league)
    else
      render :new
    end
  end

  def show
    @league = League.find(params[:id])
    @teams = @league.teams.sort_by { |team| -team[:points] }
    @team = Team.where(["league_id = ? and user_id = ?", params[:id], current_user.id]).first
    @selections = @team.selections.sort_by { |player| player[:position] }
    @chatroom = Chatroom.where("league_id = ?", params[:id]).first
  end

  def edit
    @league = League.find(params[:id])
    @teams = @league.teams
    @token = @league.token
  end


  def update
    @league = League.find(params[:id])
    @league.update(league_params)

    redirect_to edit_league_path(@league)
  end

  def token
    league = League.find_by(token: params[:token])
    redirect_to edit_league_path(league)
  end


  private

  def league_params
    params.require(:league).permit(:name, :number_of_users)
  end
end
