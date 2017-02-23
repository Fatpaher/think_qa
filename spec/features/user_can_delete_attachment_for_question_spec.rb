require 'rails_helper'

feature 'user can delete attahcment for created question' do
  context 'signed in user' do
    given(:user) { create(:user) }
    background do
      sign_in user
    end

    scenario 'user is author of question', js: true do
      question = create(:question, user_id: user.id)
      attachment = create(:attachment, :for_question, attachable_id: question.id)
      visit question_path(question)

      within '.question-attahcments' do
        click_on 'Delete'
        expect(page).not_to have_content(attachment.file.filename)
      end
      expect(page).to have_content('Attachment successfully deleted')
    end

    scenario 'user is not author of question' do
      question = create(:question)
      create(:attachment, :for_question, attachable_id: question.id)
      visit question_path(question)

      within '.question-attahcments' do
        expect(page).not_to have_content('Delete')
      end
    end
  end

  scenario 'user not signed in' do
    question = create(:question)
    create(:attachment, :for_question, attachable_id: question.id)
    visit question_path(question)

    within '.question-attahcments' do
      expect(page).not_to have_content('Delete')
    end
  end
end
