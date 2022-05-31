class Player < ApplicationRecord
  has_many :selections
  has_many :teams, through: :selections
end
