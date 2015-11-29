require 'spec_helper'

feature 'Session' do

  scenario 'Visit login' do
    visit new_user_session_path
  end

  scenario 'Visit registration' do
    visit new_user_registration_path
    expect(page).to have_content 'Email'
  end

  scenario 'Log in' do
    user = create :user
    visit new_user_session_path
    page.find_field('email').set user.email
    page.find('password').set user.password
    #page.click 'submit'
  end

end