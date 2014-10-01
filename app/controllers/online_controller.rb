class OnlineController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    user_id, room_id = params[:user_id].to_i, params[:room_id].to_i
    Online.new params[:id], user_id, room_id
    publish_online user_id, room_id
    render nothing: true
  end

  def destroy
    user_id, room_id = Online.destroy params[:id]
    publish_offline user_id, room_id unless user_id.nil? || room_id.nil?
    render nothing: true
  end

  private

  def publish_online(user_id, room_id)
    channel = Chat::Application.config.faye_online_channel + room_id.to_s
    publish channel, "#{user_id}:online"
  end

  def publish_offline(user_id, room_id)
    channel = Chat::Application.config.faye_online_channel + room_id.to_s
    publish channel, "#{user_id}:offline"
  end
end
