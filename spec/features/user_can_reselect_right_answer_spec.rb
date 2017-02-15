require 'rails_helper'

feature 'author of question can re-select best answer' do
  scenario 'can select another right question', js: true do
    user = create(:user)
    sign_in user
    question = create(:question, user_id: user.id)
    _right_answer = create(:answer, question_id: question.id, created_at: 1.day.ago)
    _new_right_answer = create(:answer, question_id: question.id, created_at: 2.days.ago)

    visit question_path(question)

    within page.all('.answer')[1] do
      click_on 'Right Answer'
    end
    wait_for_ajax

    within page.all('.answer')[1] do
      expect(page).to have_css('.right-answer-icon')
    end
  end
end
