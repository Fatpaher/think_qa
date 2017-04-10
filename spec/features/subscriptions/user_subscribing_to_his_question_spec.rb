require 'rails_helper'

feature 'user is subscribed for email notifications for his question' do

  given(:author) { create :user }
  given(:user) { create :user }
  given(:question_attr) { attributes_for :question}
  given(:answer_attr) { attributes_for :answer}

  scenario 'user create question', js: true do
    Sidekiq::Testing.inline! do
      sign_in author

      visit new_question_path
      create_question(question_attr)

      click_on 'Log out'

      sign_in user
      visit question_path(Question.last)
      create_answer(answer_attr)

      sleep 0.5
      open_email author.email
      expect(current_email).to have_content answer_attr[:body]
    end
  end
end
