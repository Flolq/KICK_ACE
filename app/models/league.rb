class League < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :teams, dependent: :destroy
  has_many :users, through: :teams
  has_many :selections, through: :teams
  has_one_attached :photo

  validates :name, presence: true, uniqueness: true
  validates :photo, presence: true
  validates :number_of_users, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 8 }
end
