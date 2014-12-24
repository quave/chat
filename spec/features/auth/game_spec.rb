require 'spec_helper'

feature 'Main page' do
  include_context 'authed'

  let!(:game) { create(:game) }

  scenario 'Visit game' do
    visit game_path(game)
    expect(page).to have_text game.name
  end

end