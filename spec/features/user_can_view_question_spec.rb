require 'rails_helper'

feature 'user visit question page' do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question_id: question.id) }

  scenario 'sees question title and body and all answers to it' do
    visit question_path(question)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end
