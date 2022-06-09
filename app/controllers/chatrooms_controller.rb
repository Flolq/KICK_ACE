class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @leagues = League.where(user_id: current_user)
    @league = @chatroom.league
    @message = Message.new
  end
end
