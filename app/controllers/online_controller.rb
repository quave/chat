class OnlineController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    render nothing: true
  end

  def destroy
    render nothing: true
  end
end
