require 'spec_helper'

feature 'User profile' do
  context :authed do
    include_examples 'authed'

    scenario 'Visit my profile' do
      visit profile_path
      expect(page).to have_content current_user.name
    end

    scenario 'Edit my profile' do
      visit profile_path
      page.find('.save').click
    end

    scenario 'Visit others\'s profile' do
      user = create :user
      visit profile_path(user.name)
      expect(page).to have_content user.name
    end
  end
end