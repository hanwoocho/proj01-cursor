class RoomsController < ApplicationController
  before_action :require_login

  def index
    @rooms = Room.order(created_at: :desc)
    @room = Room.new
  end

  def show
    @room = Room.find(params[:id])
    @message = Message.new
    @messages = @room.messages.includes(:user)
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to @room, notice: "채팅방이 생성되었습니다."
    else
      @rooms = Room.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :description)
  end
end
