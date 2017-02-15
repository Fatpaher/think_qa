require 'rails_helper'

feature 'user can select best answer' do
  context 'sign in' do
    given(:user) { create(:user) }
    before { sign_in user }

    context 'author of question' do
      scenario 'can select best answer', js: true do
        question = create(:question, user_id: user.id)
        create(:answer, question_id: question.id)

        visit question_path(question)
        within page.all('.answer').first do
          click_on 'Right Answer'
        end
        expect(page).to have_css('.right-answer-icon')
        expect(page).to have_content('Right Answer selected')
      end
    end

    context 'not author of question' do
      scenario "cant' select best answer" do
        question = create(:question)
        create(:answer, question_id: question.id)
        visit question_path(question)
        expect(page).not_to have_content('Right Answer')
      end
    end
  end

  context 'not sign in' do
    scenario "cant' select best answer" do
      question = create(:question)
      create(:answer, question_id: question.id)
      visit question_path(question)
      expect(page).not_to have_content('Right Answer')
    end
  end
end
