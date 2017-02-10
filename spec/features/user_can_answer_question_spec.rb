require 'rails_helper'

feature 'user visit question page' do
  let(:question) { create(:question) }

  context 'signed in' do
    before { sign_in create(:user) }

    scenario 'can answer question with valiid attributes' do
      answer = 'answer to question'

      visit question_path(question)
      fill_in 'Your Answer', with: answer
      click_on 'Post Answer'

      expect(page).to have_content(answer)
    end

    scenario "can't answer with invalid attributes" do
      invalid_answer = ''

      visit question_path(question)
      fill_in 'Your Answer', with: invalid_answer
      click_on 'Post Answer'

      expect(page).to have_content("Body can't be blank")
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
