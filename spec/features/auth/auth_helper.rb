require 'spec_helper'

include Devise::TestHelpers
include Warden::Test::Helpers

RSpec.configure do |config|
  config.before(:suite) do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  config.after(:each) do
    Warden.test_reset!
  end
end
