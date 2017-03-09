require 'rails_helper'

feature 'user create new question' do
  context 'signed in' do
    before { sign_in create(:user) }
    scenario 'with valid attributes' do
      question = attributes_for(:question)

      visit new_question_path
      create_question(question)

      expect(page).to have_content(question[:title])
      expect(page).to have_content(question[:body])
      expect(page).to have_content('Question successfully created')
    end

    scenario 'with invalid attributes' do
      invalid_question = attributes_for(:question, :invalid)

      visit new_question_path
      create_question(invalid_question)
      create_question(invalid_question)

      expect(page).to have_content("Title can't be blank")
    end
  end

  context 'multiple session' do
    given(:user) { create :user }
    given(:question) { attributes_for :question }
    scenario "question appears in another user's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end
      Capybara.using_session('guest') do
        visit questions_path
      end
      Capybara.using_session('user') do
        click_on 'Ask Question'
        create_question(question)
        expect(page).to have_content(question[:title])
      end
      Capybara.using_session('guest') do
        expect(page).to have_content(question[:title])
      end
    end
  end

  context 'not signed in' do
    scenario "user can't ask question" do
      visit questions_path
      expect(page).not_to have_link('Ask question')
    end
  end
end
