require 'spec_helper'

feature 'Main page' do
  let!(:game) { create(:game) }

  scenario 'Visit game' do
    visit root_path
    click_link game.name
    expect(page).to have_text(game.name)
  end

  context :authed do
    include_examples 'authed'

    scenario 'Visit game' do
      visit game_path(game)
      expect(page).to have_text game.name
    end

    scenario 'Visit room' do
      visit game_path(game)
      room_name = page.find(:css, '#room-list > ul > li > a:first').text
      click_link room_name
      expect(page).to have_text room_name
    end
  end
end