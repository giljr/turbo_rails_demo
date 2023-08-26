class MessagesController < ApplicationController
  before_action :set_room, only: %i[new create]

  def index
    @messages = @room.messages
  end

  def new
    @message = @room.messages.new
  end

  def create
    @message = @room.messages.create!(message_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @room }
    end
  end

  def edit
    @message = @room.messages.find(params[:id])
  end

  def update
    @message = @room.messages.find(params[:id])
    if @message.update(message_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to room_messages_path(@room) }
      end
    else
      # Handle validation errors
    end
  end

  def destroy
    @message = @room.messages.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@message) }
      format.html { redirect_to room_messages_path(@room) }
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
