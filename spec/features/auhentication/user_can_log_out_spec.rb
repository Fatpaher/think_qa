require 'rails_helper'

feature 'user can log out' do
  scenario 'user was signed in' do
    user = create(:user)
    sign_in(user)

    click_on 'Log out'
    expect(page).to have_content('Signed out successfully.')
    expect(current_path).to eq(root_path)
  end
  scenario "user wasn't sign in" do
    visit root_path
    expect(page).not_to have_link('Log out')
  end
end
