class SelectionController < ApplicationController
  def update
    @selection = Selection.find("player_id = ? and team_id = ?", params[:player_id], params[:team_id])

    if @selection.update(selection_params)
      redirect_to team_path(@selection.team)
    else
      render "teams/show"
    end
  end

  private

  def selection_params
    params.require(:selection).permit(:position)
  end
end
