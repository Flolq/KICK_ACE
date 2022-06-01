class SelectionsController < ApplicationController
  def update
    @selection = Selection.find(params[:id])

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
