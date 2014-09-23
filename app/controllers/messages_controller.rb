require 'eventmachine'

class MessagesController < ApplicationController
  before_action :set_message, only: [:destroy]
  before_action :set_game, only: :create
  before_action :set_room, only: :create

  def initialize
    @@client = Faye::Client.new Chat::Application.config.faye_url + 'faye'
  end

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # POST /messages
  # POST /messages.json
  def create
    unless user_signed_in? && @game.in_party?(current_user)
      render :file => "public/401.html", :status => :unauthorized
      return nil
    end

    @message = Message.new message_params
    @message.sender = @game.get_character_for current_user
    @message.save!

    publish @message
    nil
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    redirect_to @room
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:body, :room_id)
  end

  def set_game
    @game = Game.find params[:game_id]
  end

  def set_room
    @room = Room.find params[:room_id]
  end

  def publish(message)
    EM.run do
      channel = "/messages/new/#{params[:room_id]}"
      @@client.publish channel, message: render(message), ext: {auth_token: FAYE_TOKEN }
    end
  end
end
