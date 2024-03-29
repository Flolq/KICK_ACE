require 'open-uri'

class TeamsController < ApplicationController
  before_action :secured_selections, only: [:submitted, :results, :show, :final]
  before_action :defining_remaining_players, only: [:submitted, :results, :final]

  default_team_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654592216/m5mgvwp8xxgk5tnuxxnh.png"
  sheep_team_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673483/qhy1nedxjpxku4n923jp.jpg"
  tiger_team_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673549/zbqzzyuagbgrkwwxw1qy.jpg"
  unicorn_team_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673566/a7lwqa6tdcnzpsrearub.jpg"
  bear_team_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673581/e1a1of847zzg1lbwycgg.jpg"
  croco_team_photo = "https://res.cloudinary.com/dx5ha1ecm/image/upload/v1654673605/zj1pydk3lu6wdy1yxodm.jpg"

  TEAM_PICS = [
    [default_team_photo, default_team_photo],
    [sheep_team_photo, sheep_team_photo],
    [tiger_team_photo, tiger_team_photo],
    [unicorn_team_photo, unicorn_team_photo],
    [bear_team_photo, bear_team_photo],
    [croco_team_photo, croco_team_photo]
  ]

  def new
    @league = League.find(params[:league_id])
    @team = Team.new
    @photos = TEAM_PICS
  end

  def create
    @photos = TEAM_PICS
    @league = League.find(params[:league_id])
    @team = Team.new(team_params)

    if params[:team][:photo] != ""
      file = URI.open(params[:team][:photo])
      @team.photo.attach(io: file, filename: 'team.jpg', content_type: 'image/jpg')
      @team.league = @league
      @team.user = current_user
      @team.progress = "starting"
      @team.budget = 500
      @league.save
      if @team.save
        redirect_to bidding_path(@league.id, @team.id)
      end
    else
      render :new
    end
  end

  def bidding
    @team = Team.find(params[:id])
    @league = @team.league

    search_players

    if @team.progress == "submitted_ready"
      @team.increment_round
      @team.save!
      auctions(@league)
      updating_budget
    end

    secured_selections
    defining_remaining_players

    if @current_user_secured_selections.length == 8
      redirect_to final_path(@league, @team)
      return
    end

    @team.progress = "bidding"
    @team.save!
  end

  def submitted
    @team = Team.find(params[:id])
    @league = @team.league

    @team.progress = "submitted_waiting"

    filtering_selections

    @team.save

    if @league.all_waiting_and_same_round?(@team.round_number)
      @league.make_all_teams_ready(@team.round_number)
    end
    @league.save

  end

  def final
    @team.progress = "finalized"
    @current_user_secured_selections.sort_by!{ |selection| selection.player.ranking}

    @current_user_secured_selections.each_with_index do |selection, index|
      selection.position = index + 1
      selection.save!
    end

    @team.save!
  end


  def show
    @team = Team.find(params[:id])
    @selections = @current_user_secured_selections.sort_by { |player| player.position }

    @selections.each do |selection|
      player = selection.player
      matches = Match.where(player1: player).or(Match.where(player2: player)).order(date: :desc)
      points = matches.nil? ? 0 : player_points(matches, player)
      selection.player_points = points * ( BONUS_MULTIPLICATOR["pos#{selection.position}".to_sym] || 0 )
      selection.save!
    end
  end

  private

  def team_params
    params
      .require(:team)
      .permit(:name, selections_attributes: [:player_id, :price, :round_number])
  end

  def secured_selections
    @team = Team.find(params[:id])
    @league = @team.league
    @current_user_secured_selections = []
    @opponents_secured_selections = []
    @league.selections.each do |selection|
      if selection.progress == "bid_won"
        if current_user == User.joins(:teams).where("user_id = ?", selection.team.user_id)[0]
          @current_user_secured_selections << selection
        else
          @opponents_secured_selections << selection
        end
      end
    end
  end

  def defining_remaining_players
    @remaining_players = []
    @players_selected = []
    @players = Player.all.order(min_price: :desc).first(50)
    selections = @league.selections
    won_selections = []
    selections.each do |selection|
      if selection.progress == "bid_won"
        won_selections << selection
      end
    end

    won_selections.each do |selection|
      @players_selected << selection.player
    end

    @players.each do |player|
      unless @players_selected.include?(player)
        @remaining_players << player
      end
    end
  end

  def player_points(matches, player)
    points = 0

    matches.each do |match|
      if match.winner == player
        points += ((player.ranking - (player == match.player1 ? match.player2.ranking : match.player1.ranking)) + 100) * 8
        if match.round.split("\"")[3] == "final" && match.tournament.level == "atp_1000"
          points += 2000
        elsif match.round.split("\"")[3] == "final" && match.tournament.level == "grand_slam"
          points += 5000
        end
      elsif match.tournament.level == "atp_1000"
        points += (ATP_1000_ROUND_POINTS[match.round.split("\"")[3].to_sym] || 0) unless ATP_1000_ROUND_POINTS[match.round.split("\"")[3]].nil?
      else
        points += (GRAND_SLAM_ROUND_POINTS[match.round.split("\"")[3].to_sym] || 0) unless ATP_1000_ROUND_POINTS[match.round.split("\"")[3]].nil?
      end
    end

    return points
  end

  def add_player_points(match, player)
    points = 0

    if match.winner == player
      points += ((player.ranking - (player == match.player1 ? match.player2.ranking : match.player1.ranking)) + 200) * 8
      if match.round.split("\"")[3] == "final" && match.tournament.level == "atp_1000"
        points += 2000
      elsif match.round.split("\"")[3] == "final" && match.tournament.level == "grand_slam"
        points += 5000
      end
    elsif match.tournament.level == "atp_1000"
      points += (ATP_1000_ROUND_POINTS[match.round.split("\"")[3].to_sym] || 0) unless ATP_1000_ROUND_POINTS[match.round.split("\"")[3]].nil?
    else
      points += (GRAND_SLAM_ROUND_POINTS[match.round.split("\"")[3].to_sym] || 0) unless ATP_1000_ROUND_POINTS[match.round.split("\"")[3]].nil?
    end

    return points
  end

  def auctions(league)
    @team = Team.find(params[:id])
    league_selections = league.selections
    submitted_selections = []

    league_selections.each do |selection|
      if (selection.progress == "bid_submitted") && (selection.round_number == @team.round_number - 1)
        submitted_selections << selection
      end
    end

    grouped_selections = submitted_selections.group_by { |selection| selection.player_id }

    @starting_budget = @team.budget
    @budget_spent = 0

    grouped_selections.each do |_player_id, player_selections|
      if player_selections.length == 1
        winning_selection = player_selections[0]
        winning_selection.progress = "bid_won"
        winning_selection.save!
      else
        max_price = determine_max_price(player_selections)
        selections_by_price = player_selections.sort_by { |selection| selection.price }.reverse!
        if selections_by_price[0] != selections_by_price[1]
          winning_selection = selections_by_price[0]
        else
          selections_at_max_price = player_selections.select { |selection| selection.price == max_price }
          winning_selection = selections_at_max_price.min_by { |selection| selection.updated_at }
        end
        losing_selections = player_selections.excluding(winning_selection)
        winning_selection.progress = "bid_won"
        winning_selection.save!
        losing_selections.each do |selection|
          selection.progress = "bid_lost"
          selection.save!
        end
      end
    end
    @team.save!
  end

  def search_players
    if params[:query].present?
      sql_query = " \
      players.first_name @@ :query \
      OR players.last_name @@ :query \
    "
      @players = Player.where(sql_query, query: "%#{params[:query]}%")
    else
      @players = Player.all
    end
    respond_to do |format|
      format.html
      format.text { render partial: 'teams/list', locals: { players: @players }, formats: [:html] }
    end
  end

  def updating_budget
    starting_budget = @team.budget
    budget_spent = 0
    @team.selections.each do |selection|
      if (selection.progress == "bid_won") && (selection.round_number == @team.round_number - 1)
        budget_spent += selection.price
      end
    end
    @team.budget = starting_budget - budget_spent
    @team.save
  end


  # def progressing_league_round_progress
  #   @league.round_progress = "bidding_submitted" if @teams_submitted.length == @league.number_of_users
  #   @league.round_progress = "finalized" if @teams_finalized.length == @league.number_of_users
  #   @league.save
  # end

  def filtering_selections
    filtered_selections = []
    @kept_selections = []
    team = Team.find(params[:id])

    all_selections = @team.selections
    all_selections.each do |selection|
      filtered_selections << selection if selection.round_number == team.round_number
    end

    grouped_selections = filtered_selections.group_by { |selection| selection.player_id }
    grouped_selections.each do |_player_id, player_selections|
      players_selections = player_selections.sort_by { |selection| selection.updated_at }.reverse
      players_selections[0].progress = "bid_submitted"
      players_selections[0].save
      @kept_selections << players_selections[0]
    end
  end

  def determine_max_price(selections)
    selections.max_by{ |selection| selection.price }.price
  end
end
