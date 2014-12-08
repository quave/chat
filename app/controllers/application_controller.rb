require 'eventmachine'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :get_layout
  helper_method :forem_user

  def forem_user
    current_user
  end

  protected

  def set_game_lists
    @my_games = Game.for current_user
    @current_games = Game.not_started + Game.started
  end

  def publish(channel, message)
    EM.run do
      Chat::Application.faye_client.publish channel, message: message, ext: {auth_token: FAYE_TOKEN }
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :name, :email, :password, :password_confirmation
    end
  end

  def get_layout
    return 'application' if devise_controller? && controller_name == 'registrations' && ['edit', 'show'].include?(action_name)
    nil
  end
end
