class LobbyController < ApplicationController

  def index
    @my_games = Game.for current_user
    @current_games = Game.all
  end

end
