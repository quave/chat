require 'spec_helper'

RSpec.shared_context 'authed' do
  before (:each) do
    user = FactoryGirl.create(:user)
    login_as user, :scope => :user, :run_callbacks => false
  end


end