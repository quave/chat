require_relative 'auth_helper'

feature 'Main page' do

  scenario 'Visit main page' do
    visit root_path
    expect(page).not_to have_selector '.btn-sign-up'
  end

end