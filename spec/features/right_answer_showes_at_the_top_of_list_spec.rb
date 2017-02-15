require 'rails_helper'

describe 'right answer shows first in the list' do
  scenario 'user visit page with selected right answer' do
    sign_in create(:user)
    question = create(:question)
    _other_answer = create(:answer, question_id: question.id, created_at: 1.day.ago)
    right_answer = create(:answer, body: '1', question_id: question.id, created_at: 2.days.ago)
    question.right_answer = right_answer
    question.save

    visit question_path(question)

    within page.all('.answer').first do
      expect(page).to have_css('.right-answer-icon')
    end
  end
end

