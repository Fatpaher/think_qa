require 'rails_helper'

feature 'user can authenticate with omniauth providers' do
  given(:user) { create :user}
  given(:new_user) { attributes_for :user}

  context 'provider sends user email' do
    scenario 'new user' do
      OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: new_user[:email] } } )
      visit new_user_session_path

      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end

    scenario 'existed user' do
      OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: user.email } } )
      visit new_user_session_path

      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end
  end

  context "provider doesn't send email" do
    context 'new user' do
      given(:new_user) { attributes_for :user}
      scenario 'user can add his email' do
        OmniAuth.config.add_mock(:twitter, {uid: '12345'} )
        visit new_user_session_path

        click_on 'Sign in with Twitter'
        fill_in 'Email', with: new_user[:email]
        click_on 'Add'

        open_email(new_user[:email])
        expect(current_email.subject).to eq('Confirmation instructions')
      end
    end

    context 'existed user' do
      given!(:user) { create :user }
      scenario 'user can authenticate' do
        OmniAuth.config.add_mock(:twitter, {uid: '12345' } )

        visit new_user_session_path
        click_on 'Sign in with Twitter'
        fill_in 'Email', with: user.email
        click_on 'Add'

        expect(page).to have_content 'Successfully authenticated from Twitter account'
      end
    end
  end
end