class LobbyController < ApplicationController

  def index
    @my_games = Game.where(creator_id: current_user.id) if user_signed_in?
    @current_games = Game.all
  end

end
