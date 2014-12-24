require 'spec_helper'

feature 'Main page' do
  before(:each) do
    user = FactoryGirl.create(:user)
    login_as user, :scope => :user, :run_callbacks => false
  end

  let!(:game) { create(:game) }

  scenario 'Visit game' do
    visit game_path(game)
    expect(page).to have_text game.name
  end

end