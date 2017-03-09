require 'rails_helper'

feature 'user can see comments to question' do
  given(:question) { create :question }
  given!(:comment) { create :comment, commentable: question}

  scenario 'user visit question path and see comments to question' do
    visit question_path(question)

    within '.question-comments' do
      expect(page).to have_content(comment.body)
    end
  end
end
