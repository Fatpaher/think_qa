require 'rails_helper'

feature 'user visit question page', js: true do
  let(:question) { create(:question) }

  context 'signed in' do
    before { sign_in create(:user) }

    scenario 'can answer question with valiid attributes' do
      answer = attributes_for(:answer)

      visit question_path(question)
      create_answer(answer)

      expect(page).to have_content(answer[:body])
    end

    scenario "can't answer with invalid attributes" do
      invalid_answer = attributes_for(:answer, :invalid)

      visit question_path(question)
      create_answer(invalid_answer)

      expect(page).to have_content("Body can't be blank")
    end
  end

  context 'multiple session', js: true do
    given(:author) { create :user }
    given(:user) { create :user }
    given(:answer) { attributes_for :answer }

    scenario 'answer appears in other sessions' do
      Capybara.using_session('author') do
        sign_in author
        visit question_path(question)
      end
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        create_answer(answer)
      end
      Capybara.using_session('user') do
        within '.answers' do
          expect(page).to have_content(answer[:body])
          expect(page).to have_css('.vote-up-button')
          expect(page).to have_css('.vote-down-button')
        end
      end
      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content(answer[:body])
          expect(page).not_to have_css('.vote-up-button')
          expect(page).not_to have_css('.vote-down-button')
        end
      end
    end
  end

  context 'not signed in' do
    scenario "can't see answer form" do
      visit question_path(question)
      expect(page).not_to have_field('Your Answer')
      expect(page).to have_content('To answer the question you must sign in')
    end
  end
end
