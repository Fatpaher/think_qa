require 'rails_helper'

feature 'user can vote for answer only once' do
  given!(:question) { create(:question) }
  context 'signed in user' do
    given(:user) { create(:user)}
    given!(:answer) { create(:answer, question_id: question.id) }
    background { sign_in user }

    context 'user is not author of answer' do
      background { visit question_path(question) }

      scenario 'user can upvote answer', js: true do
        within '.answers' do
          click_on('+1')
          expect(page).to have_content('Rating 1')

          expect(page).not_to have_css('.vote-up-button')
          expect(page).not_to have_css('.vote-down-button')
        end
      end

      scenario 'user can downvote answer', js: true do
        within '.answers' do
          click_on('-1')
          expect(page).to have_content('Rating -1')

          expect(page).not_to have_css('.vote-up-button')
          expect(page).not_to have_css('.vote-down-button')
        end
      end

      context 'user already voted' do
        given(:answer) { create(:answer) }
        let!(:vote) { create(:vote, :for_answer, votable: answer, user_id: user.id) }
        it_behaves_like "can't see answer vote buttons"
      end
    end

    context 'user is author of answer' do
      given!(:answer) { create(:answer, user_id: user.id, question_id: question.id) }
      it_behaves_like "can't see answer vote buttons"
    end
  end

  context 'not signed in user' do
    given!(:answer) { create(:answer, question_id: question.id) }
    it_behaves_like "can't see answer vote buttons"
  end
end
