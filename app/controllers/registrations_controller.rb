class RegistrationsController < Devise::RegistrationsController
  def edit
    if params[:name].nil?
      super
      return
    end
    @user = User.find_by name: params[:name]
    render :show
  end
end