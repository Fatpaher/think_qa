require 'rails_helper'

feature 'user can see comments to answer' do
  given(:question) { create :question }
  given(:answer) { create :answer, question: question }
  given!(:comment) { create :comment, commentable: answer}

  scenario 'user visit question path and see comments to question' do
    visit question_path(question)

    within '.answer-comments' do
      expect(page).to have_content(comment.body)
    end
  end
end
