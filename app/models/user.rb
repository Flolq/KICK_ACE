require "open-uri"
require "nokogiri"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :teams
  has_many :leagues, through: :teams
  has_many :selections, through: :teams
  has_many :messages

  validates :nickname, presence: true
end
