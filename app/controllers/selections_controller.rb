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
    @selection.update(selection_params)
  end

  def destroy
    @selection = Selection.find([params[:id]])
    @selection.destroy
  end


  private

  def selection_params
    params.require(:selection).permit(:position, :player_id, :price, :team_id, :round_number)
  end
end
