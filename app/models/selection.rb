class Selection < ApplicationRecord
  belongs_to :team
  belongs_to :player

  validates :price, presence: true
  acts_as_list scope: :team
end
