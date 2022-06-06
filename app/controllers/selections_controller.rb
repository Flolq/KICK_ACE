class SelectionsController < ApplicationController

  def new
    @selection = Selection.new
    @player = Player.find(params[:player_id])
    @team = Team.find(params[:team_id])
    @selection.team = @team
    @selection.player = @player
    render partial: "new", locals: {selection: @selection}
  end

  def create
    @selection = Selection.new(selection_params)
    @selection.progress = "bidding"
    @selection.save
  end


  def update
    @selection = Selection.find(params[:id])

    if @selection.update(selection_params)
      redirect_to team_path(@selection.team)
    else
      render "teams/show"
    end
  end

  def destroy
    @selection = Selection.find([params[:id]])
    @selection.destroy
  end


  private

  def selection_params
    params.require(:selection).permit(:position, :player_id, :team_id, :price)
  end
end
