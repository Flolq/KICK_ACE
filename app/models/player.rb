class Player < ApplicationRecord
  has_many :selections
  has_many :teams, through: :selections

  has_many :matches
  has_one_attached :photo

  include PgSearch::Model
  pg_search_scope :search_by_first_name_and_last_name,
    against: [ :first_name, :last_name ],
    using: {
      tsearch: { prefix: true }
    }

end
