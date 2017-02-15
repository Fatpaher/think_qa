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
          click_on 'Best Answer'
        end
        expect(page).to have_css('.best-answer-icon')
        expect(page).to have_content('Best Answer selected')
      end

      scenario 'can select another best question', js: true do
        question = create(:question, user_id: user.id)
        _best_answer = create(:answer, :best_answer, question_id: question.id, created_at: 1.day.ago)
        _new_best_answer = create(:answer, question_id: question.id, created_at: 2.days.ago)

        visit question_path(question)

        within page.all('.answer')[1] do
          click_on 'Best Answer'
        end
        wait_for_ajax

        within page.all('.answer').first do
          expect(page).to have_css('.best-answer-icon')
        end
      end
    end

    context 'not author of question' do
      scenario "cant' select best answer" do
        question = create(:question)
        create(:answer, question_id: question.id)
        visit question_path(question)
        expect(page).not_to have_content('Best Answer')
      end
    end
  end

  context 'not sign in' do
    scenario "cant' select best answer" do
      question = create(:question)
      create(:answer, question_id: question.id)
      visit question_path(question)
      expect(page).not_to have_content('Best Answer')
    end
  end
end
