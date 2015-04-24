require 'spec_helper'

RSpec.shared_examples 'authed' do
  let (:current_user) { create :user }

  before (:each) do
    login_as current_user, :scope => :user, :run_callbacks => false
  end

  scenario 'Visit main page' do
    visit root_path
    expect(page).to have_text 'Выход'
  end

end