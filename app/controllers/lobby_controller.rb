class LobbyController < ApplicationController

  def index
    @my_games = Game.for current_user
    @current_games = Game.not_started + Game.started
  end

end
