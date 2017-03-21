require 'rails_helper'

feature 'user can registrate' do
  given(:email) { 'foo@bar.com' }

  scenario 'with valid data' do
    password = '12345678'
    visit new_user_registration_path

    within '.main-content' do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password
      click_on 'Sign up'
    end

    open_email(email)

    expect(current_email).to have_content 'Confirm my account'
  end

  scenario 'with invalid password confirmation' do
    password = '12345678'
    invalid_password_confirmation = '876543231'
    visit new_user_registration_path

    within '.main-content' do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: invalid_password_confirmation
      click_on 'Sign up'
    end

    expect(page).to have_content("Password confirmation doesn't match")
  end
end
