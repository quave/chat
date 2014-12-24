require 'spec_helper'

feature 'Main page' do
  before(:each) do
    user = FactoryGirl.create(:user)
    login_as user, :scope => :user, :run_callbacks => false
  end

  scenario 'Visit main page' do
    visit root_path
    expect(page).not_to have_selector '.btn-sign-up'
  end

end