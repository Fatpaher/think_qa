require 'rails_helper'

feature 'user can reset his vote for answer' do
  given(:user) { create(:user)}
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question_id: question.id) }
  given!(:vote) { create(:vote, :for_answer, votable: answer, user_id: user.id) }

  background { sign_in user }
  scenario 'user already voted can reset git vote and can vote again', js: true do
    visit question_path(question)
    within '.answers' do
      click_on 'Reset Vote'

      expect(page).to have_content('Rating 0')
      expect(page).not_to have_content('Reset Vote')
      expect(page).to have_css('.vote-up-button')
      expect(page).to have_css('.vote-down-button')
    end
  end
end
