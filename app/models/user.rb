require "open-uri"
require "nokogiri"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :teams
  has_many :leagues, through: :teams
  has_many :selections, through: :teams
  has_many :messages
  after_invitation_accepted :invite_accepted

  def invite_accepted
    redirect_to leagues_path
  end
end
