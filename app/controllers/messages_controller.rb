class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_room

  def create
    @message = @room.messages.build(message_params.merge(user: current_user))

    if @message.save
      render turbo_stream: turbo_stream.replace(
        "message_form",
        partial: "messages/form",
        locals: { room: @room, message: Message.new }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "message_form",
        partial: "messages/form",
        locals: { room: @room, message: @message }
      ), status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
