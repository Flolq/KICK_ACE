class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @leagues = @user.leagues
  end

  private

  def set_user
    @user = current_user
  end
end
