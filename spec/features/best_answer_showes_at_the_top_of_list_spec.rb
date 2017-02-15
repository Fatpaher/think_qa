require 'rails_helper'

describe 'best answer shows first in the list' do
  scenario 'user visit page with selected best answer' do
    sign_in create(:user)
    question = create(:question)
    _other_answer = create(:answer, question_id: question.id, created_at: 1.day.ago)
    best_answer = create(:answer, :best_answer, question_id: question.id, created_at: 2.days.ago)

    visit question_path(question)

    within page.all('.answer').first do
      expect(page).to have_css('.best-answer-icon')
      expect(page).to have_content(best_answer.body)
    end
  end
end

