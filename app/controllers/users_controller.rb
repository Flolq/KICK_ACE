require "open-uri"
require "nokogiri"

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    #@leagues = @user.leagues
    @leagues = League.joins(:teams).where(["teams.user_id = ?", current_user.id]).order(id: :desc)

    url = "https://www.tennisactu.net/"
    html_file = URI.open(url).read
    @html_doc = Nokogiri::HTML(html_file)
  end

  private

  def set_user
    @user = current_user
  end
end
