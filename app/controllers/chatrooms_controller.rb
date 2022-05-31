class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:league_id])
  end
end
