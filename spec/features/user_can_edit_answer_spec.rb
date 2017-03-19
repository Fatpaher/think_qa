require 'rails_helper'

feature 'user can edit answer' do
  given!(:question) { create(:question) }

  context 'signed in' do
    given(:user) { create(:user) }

    before { sign_in user }

    context 'edit his answer', js: true do
      given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
      scenario 'with valid params' do
        edited_answer = attributes_for(:answer)

        visit question_path(question)

        within '.answers' do
          click_on 'Edit'
          fill_in 'Answer', with: edited_answer[:body]
          click_on 'Save'
        end

        expect(page).to have_content('Answer was successfully updated')
        expect(page).to have_content(edited_answer[:body])
        expect(page).not_to have_content(answer.body)
      end

      scenario 'with invalid params' do
        invalid_edited_answer = attributes_for(:answer, :invalid)

        visit question_path(question)

        within '.answers' do
          click_on 'Edit'
          fill_in 'Answer', with: invalid_edited_answer[:body]
          click_on 'Save'
        end

        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'edit other user answer' do
      create(:answer, question_id: question.id)

      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_content('Edit')
      end
    end
  end

  context 'not signed in' do
    scenario 'try to edit answer' do
      create(:answer, question_id: question.id)

      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_content('Edit')
      end
    end
  end
end
