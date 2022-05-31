class LeaguesController < ApplicationController
  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    @league.owner = current_user
    if @league.save
      redirect_to league_path(@league)
    else
      render :new
    end
  end

  def show
    @league = League.find(params[:id])
  end

  private

  def league_params
    params.require(:league).permit(:name, :number_of_users)
  end
end
