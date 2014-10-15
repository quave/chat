class ProfileController < ApplicationController
  before_action :authenticate_user!, only: [:index, :update]

  def index

  end

  def show
    @user = User.find params[:id]
  end

  def update
    notice 'Профиль успешно обновлен!'
    redirect_to profile_index_path
  end
end
