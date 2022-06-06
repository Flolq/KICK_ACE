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
    @team = @selection.team
    @selections = @team.selections.order(:position)
    selection_to_move = @selections.delete(@selection)
    @selections.insert(params[:position], selection_to_move)
    @selections.save!
    #   redirect_to team_path(@selection.team)
    # else
    #   render "teams/show"
    # end
    respond_to do |format|
      format.html { redirect_to team_path(@selection.team) }
      format.text { render partial: 'teams/players_drag', locals: { selections: @selections }, formats: [:html] }
    end
  end

  def destroy
    @selection = Selection.find([params[:id]])
    @selection.destroy
  end


  private

  def selection_params
    params.require(:selection).permit(:position)
  end
end
