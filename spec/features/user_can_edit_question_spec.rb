require 'rails_helper'

feature 'user can edit question' do
  context 'signed in' do
    given(:user) { create(:user) }

    before { sign_in user }

    context 'edit his question' , js: true do
      given(:question) { create(:question, user_id: user.id) }
      scenario 'with valid params' do
        edited_question = attributes_for(:question)

        visit question_path(question)

        click_on 'Edit Question'
        fill_in 'Title', with: edited_question[:title]
        fill_in 'Body', with: edited_question[:body]
        click_on 'Update Question'

        expect(page).to have_content('Question was successfully edit')
        expect(page).to have_content(edited_question[:title])
        expect(page).to have_content(edited_question[:body])
        expect(page).not_to have_content(question.title)
        expect(page).not_to have_content(question.body)
      end

      scenario 'with invalid params' do
        invalid_edited_question = attributes_for(:question, :invalid)

        visit question_path(question)

        click_on 'Edit Question'
        fill_in 'Title', with: invalid_edited_question[:title]
        fill_in 'Body', with: invalid_edited_question[:body]
        click_on 'Update Question'

        expect(page).to have_content("Title can't be blank")
      end
    end

    scenario 'edit other user question' do
      question = create(:question)

      visit question_path(question)

      expect(page).not_to have_content('Edit Question')
    end
  end

  context 'not signed in' do
    scenario 'try to edit question' do
      question = create(:question)

      visit question_path(question)
      expect(page).not_to have_content('Edit Question')
    end
  end
end
