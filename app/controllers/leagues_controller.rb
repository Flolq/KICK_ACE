require 'open-uri'

clay_league_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674085/pehup7q6ixsfs5leccrn.jpg"
grass_league_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674147/qfssc7nahaqlquit1czh.jpg"
grey_league_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674169/nab6cjh0c1lysyue1iho.jpg"
hard_league_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674192/qug44xflwqxgmvwazvir.jpg"
hard_blue_league_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654674207/yixcppbqr6tz0qwl2e1z.jpg"

LEAGUE_PICS = [
  [clay_league_photo, clay_league_photo],
  [grass_league_photo, grass_league_photo],
  [grey_league_photo, grey_league_photo],
  [hard_league_photo, hard_league_photo],
  [hard_blue_league_photo, hard_blue_league_photo]
]

class LeaguesController < ApplicationController

  def index
    @leagues = League.all
  end

  def new
    @league = League.new
    @photos = LEAGUE_PICS
  end

  def create
    file = URI.open(params[:league][:photo])
    @league = League.new(league_params)
    @league.photo.attach(io: file, filename: 'league.jpg', content_type: 'image/jpg')
    @league.owner = current_user
    @league.round_progress = "starting"
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
    @leagues = League.where(user_id: current_user)
    @league = League.find(params[:id])
    @team = Team.where(["league_id = ? and user_id = ?", params[:id], current_user.id]).first
    if !@team
      redirect_to edit_league_path(@league)
    elsif @league.teams.length < @league.number_of_users
      redirect_to bidding_path(@league, @team)
      return
    else
      @league = League.find(params[:id])
      @teams = @league.teams.order(points: :desc)
      @team = Team.where(["league_id = ? and user_id = ?", params[:id], current_user.id]).first
      @selections = @team.selections.sort_by { |player| player[:position] }
      @chatroom = Chatroom.where("league_id = ?", params[:id]).first
      if !@chatroom.nil?
        @message = @chatroom.messages.last
      end
    end
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
