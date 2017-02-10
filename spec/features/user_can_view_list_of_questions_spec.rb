require 'rails_helper'

feature 'user visit questions page' do
  scenario 'sees list of all questions' do
    questions = create_list(:question, 3)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end
