require 'rails_helper'

feature 'user can delete attahcment for created answer' do
  given!(:question) {create(:question)}

  context 'signed in user' do
    given(:user) { create(:user) }
    background do
      sign_in user
    end

    scenario 'user is author of answer', js: true do
      answer = create(:answer, user_id: user.id, question_id: question.id)
      attachment = create(:attachment, :for_answer, attachable_id: answer.id)
      visit question_path(question)

      within '.answer-attachments' do
        click_on 'Delete'
        expect(page).not_to have_content(attachment.file.filename)
      end
      expect(page).to have_content('Attachment was successfully destroyed')
    end

    scenario 'user is not author of answer' do
      answer = create(:answer, question_id: question.id)
      create(:attachment, :for_answer, attachable_id: answer.id)
      visit question_path(question)

      within '.answer-attachments' do
        expect(page).not_to have_content('Delete')
      end
    end
  end

  scenario 'user not signed in' do
    answer = create(:answer, question_id: question.id)
    create(:attachment, :for_answer, attachable_id: answer.id)
    visit question_path(question)

    within '.answer-attachments' do
      expect(page).not_to have_content('Delete')
    end
  end
end
