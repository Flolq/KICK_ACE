class Chatroom < ApplicationRecord
  belongs_to :league
  has_many :messages, dependent: :destroy
end
