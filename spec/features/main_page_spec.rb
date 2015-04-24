require 'spec_helper'

feature 'Main page' do
  let!(:game) { create(:game) }

  scenario 'Visit main page' do
    visit root_path
    expect(page).to have_selector '#all-games li'
  end

  scenario 'Visit login' do
    visit root_path
    within 'header' do
      click_link 'Войти'
    end
    expect(page).to have_text('Email')
  end

  scenario 'Visit registration' do
    visit root_path
    click_link 'Зарегистрироваться'
    expect(page).to have_text('Email')
  end

end