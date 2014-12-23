require 'spec_helper'

feature 'Session' do

  scenario 'Visit login' do
    visit new_user_session_path
  end

  scenario 'Visit registration' do
    visit new_user_registration_path
    expect(page).to have_content 'Email'
  end

end