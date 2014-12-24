require 'spec_helper'

feature 'Main page' do
  include_context 'authed'

  scenario 'Visit main page' do
    visit root_path
    expect(page).not_to have_selector '.btn-sign-up'
  end

end