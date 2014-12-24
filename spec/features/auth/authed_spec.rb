require 'spec_helper'

RSpec.shared_examples 'authed' do
  before (:each) do
    user = FactoryGirl.create(:user)
    login_as user, :scope => :user, :run_callbacks => false
  end

  scenario 'Visit main page' do
    visit root_path
    expect(page).to have_text 'Выход'
  end

end