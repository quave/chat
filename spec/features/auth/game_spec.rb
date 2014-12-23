require_relative 'auth_helper'

feature 'Main page' do
  let!(:game) { create(:game) }

  scenario 'Visit game' do
    visit game_path(game)
    expect(page).to have_text game.name
  end

end