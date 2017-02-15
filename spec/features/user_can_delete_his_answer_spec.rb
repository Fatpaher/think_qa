require 'rails_helper'

feature 'user visit question page' do
  given(:question) { create(:question) }

  context 'signed in' do
    given(:user) { create(:user) }
    before { sign_in user }

    scenario 'can delete his own answer', js: true do
      answer = create(:answer, user: user, question: question)
      visit question_path(question)

      click_on 'Delete'
      expect(page).to have_content('Answer successfully deleted')
      expect(page).not_to have_content(answer)
      expect(current_path).to eq(question_path(question))
    end

    scenario "can't delete question not belon to him" do
      create(:answer, question: question)

      visit question_path(question)

      expect(page).not_to have_link('Delete')
    end
  end

  context 'not signed in' do
    scenario "can't delete question" do
      create(:answer, question: question)

      visit question_path(question)

      expect(page).not_to have_link('Delete')
    end
  end
end
