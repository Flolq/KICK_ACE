class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @leagues = @user.leagues

    url = "https://www.atptour.com/en/media/rss-feed/xml-feed"

    html_file = URI.open(url).read
    @html_doc = Nokogiri::HTML(html_file)

    @html_doc.search(".title").each do |element|
      puts element.text.strip
      puts element.attribute("href").value
    end

  end

  private

  def set_user
    @user = current_user
  end
end
