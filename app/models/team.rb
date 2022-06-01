class Team < ApplicationRecord
  belongs_to :user
  belongs_to :league
  has_many :selections
  has_many :players, through: :selections
  accepts_nested_attributes_for :selections

  validates :name, presence: true
end
