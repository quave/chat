require 'eventmachine'

class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

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
    @message = Message.new(message_params)
    @message.sender = current_user
    
    @message.exec!

    if @message.should_save?
      @message.save
    else
      @message.created_at = DateTime.now
    end

    @character = Character.find_by game_id: params[:game_id], user_id: current_user.id



    channel = "/messages/new/#{params[:room_id]}"
    pub = @@client.publish channel, message: render(@message), ext: {auth_token: FAYE_TOKEN }

    pub.callback do
      #succsed
    end

    pub.errback do |e|
      #error
      logger.debug e.inspect
    end

    nil
  end

  # Push method
  def show
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  def events
    response.headers["Content-Type"]="text/event-stream"
    redis=Redis.new
    redis.subscribe('message.create') do |on|
      on.message do |event, data|
        response.stream.write("data: #{data}\n\n")
      end
    end
    response.stream.close
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
end
