require 'rails_helper'

feature 'user create new question' do
  context 'signed in' do
    before { sign_in create(:user) }
    scenario 'with valid attributes' do
      question_title = 'New question'
      question_body = 'question body'

      visit new_question_path
      fill_in 'Title', with: question_title
      fill_in 'Body', with: question_body
      click_on 'Create Question'

      expect(page).to have_content(question_title)
      expect(page).to have_content(question_body)
      expect(page).to have_content('Question succsesfully created')
    end
    scenario 'with invalid attributes' do
      invalid_question_title = ''
      question_body = 'question body'

      visit new_question_path
      fill_in 'Title', with: invalid_question_title
      fill_in 'Body', with: question_body
      click_on 'Create Question'

      expect(page).to have_content("Title can't be blank")
    end
  end

  context 'not signed in' do
    scenario "user can't ask question" do
      visit questions_path
      expect(page).not_to have_link('Ask question')
    end
  end
end
