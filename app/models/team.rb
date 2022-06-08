class Team < ApplicationRecord
  belongs_to :user
  belongs_to :league
  has_many :selections
  has_many :players, through: :selections
  has_one_attached :photo
  accepts_nested_attributes_for :selections

  validates :photo, presence: true
  validates :name, presence: true
end
