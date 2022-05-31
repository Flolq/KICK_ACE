class Message < ApplicationRecord
  belongs_to :league
  belongs_to :user
  belongs_to :chatroom

  validates :content, presence: true
end
