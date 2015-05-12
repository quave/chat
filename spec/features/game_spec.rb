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

    scenario 'Create game' do
      visit new_game_path
      game_name = 'game 1'
      page.fill_in 'game_name', with: game_name
      page.find(:css, '[name=commit]').click
      expect(page).to have_text game_name
    end

    scenario 'Create room' do
      visit new_game_room_path(game)
      room_name = 'room 1'
      page.fill_in 'room_name', with: room_name
      page.find(:css, '[name=commit]').click
      expect(page).to have_text room_name
    end

    scenario 'Create character' do
      visit new_game_character_path(game)
      char_name = 'char 1'
      page.fill_in 'character_name', with: char_name
      page.find(:css, '[name=commit]').click
      expect(page).to have_text char_name
    end
  end
end