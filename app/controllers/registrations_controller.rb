class RegistrationsController < Devise::RegistrationsController
  def edit
    if params[:name].nil?
      super
      return
    end
    @user = User.find_by! name: params[:name]
    @owned_games = Game.with_master @user
    @played_games = Game.with_player @user
    render :show
  end
end