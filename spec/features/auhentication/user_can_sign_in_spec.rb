require 'rails_helper'

feature 'user visit sign in page' do
  scenario 'regisered user try to sign in' do
    user = create(:user, password: '12345678')

    sign_in(user)

    expect(page).to have_content('Signed in successfully.')
    expect(current_path).to eq(root_path)
  end
  scenario 'not regisered user try to sign in' do
    wrong_user = build(:user)

    visit new_user_session_path
    fill_in 'Email', with: wrong_user.email
    fill_in 'Password', with: wrong_user.password
    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password.')
    expect(current_path).to eq(new_user_session_path)
  end
end
