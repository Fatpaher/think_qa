require 'rails_helper'

feature 'user visit question page' do

  context 'signed in' do
    given(:user) { create(:user) }
    before { sign_in user }

    scenario 'can delete his own question' do
      question = create(:question, user_id: user.id)
      visit question_path(question)

      click_on 'Delete Question'
      expect(current_path).to eq(questions_path)
      expect(page).to have_content('Question successfully deleted')
    end

    scenario "can't delete question not belon to him" do
      question = create(:question)
      visit question_path(question)

      expect(page).not_to have_link('Delete Question')
    end
  end

  context 'signed in' do
    scenario "can't delete question" do
      question = create(:question)
      visit question_path(question)

      expect(page).not_to have_link('Delete Question')
    end
  end

end
