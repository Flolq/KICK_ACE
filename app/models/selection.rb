class Selection < ApplicationRecord
  belongs_to :team
  belongs_to :player

  validates :price, presence: true
end
