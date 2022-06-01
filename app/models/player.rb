class Player < ApplicationRecord
  has_many :selections
  has_many :teams, through: :selections
  has_many :matches
end
