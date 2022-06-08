class League < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :teams, dependent: :destroy
  has_many :users, through: :teams
  has_many :selections, through: :teams

  validates :name, presence: true, uniqueness: true
  validates :number_of_users, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 8 }

  def complete?
    teams.length == number_of_users
  end


  def all_waiting_and_same_round?(round_number)
    teams = self.teams
    return teams.all? { |team| ((team.progress == "submitted_waiting" || team.progress == "submitted_ready") && team.round_number == round_number) || team.round_number > round_number}
  end

  def make_all_teams_ready(round_number)
    teams = self.teams
    teams.each do |team|
      team.progress = "submitted_ready" if team.round_number == round_number
      team.save
    end
  end

  def all_ready?(round_number)
    teams = self.teams
    return teams.all? { |team| ((team.progress == "submitted_ready") && (team.round_number == round_number)) || team.round_number > round_number}
  end

  def all_finalized?
    teams = self.teams
    return teams.all? { |team| team.progress == "finalized" }
  end

  def teams_submitted_waiting(round_number)
    teams = self.teams
    return teams.select { |team| ((team.progress == "submitted_waiting") && (team.round_number == round_number)) || team.round_number > round_number}
  end

  def teams_finalized(round_number)
    teams = self.teams
    return teams.select { |team| team.progress == "finalized" && team.round_number == round_number}
  end


end
