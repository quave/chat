class ChatController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_games = Game.where(creator_id: current_user.id)
    @current_games = Game.all
  end

end
