require 'spec_helper'

include Devise::TestHelpers
include Warden::Test::Helpers

unless defined? user
  Warden.test_mode!
  user = FactoryGirl.build(:user)
  user = User.find_or_create_by({ email: user.email })
  login_as(user, :scope => :user)
end

RSpec.configure do |config|
  config.after(:each) do
    Warden.test_reset!
  end
end
