require 'rails_helper'

feature 'user can vote for question only once' do
  context 'signed in user' do
    given(:user) { create(:user)}
    background { sign_in user }
    context 'user is not author of question' do
      given(:question) { create(:question) }
      background { visit question_path(question) }

      scenario 'user can upvote question', js: true do
        click_on('+1')

        expect(page).to have_content('Rating 1')

        expect(page).not_to have_css('.vote-up-button')
        expect(page).not_to have_css('.vote-down-button')
      end

      scenario 'user can downvote question', js: true do
        click_on('-1')
        expect(page).to have_content('Rating -1')

        expect(page).not_to have_css('.vote-up-button')
        expect(page).not_to have_css('.vote-down-button')
      end

      context 'user already voted' do
        given(:question) { create(:question) }
        given!(:vote) { create(:vote, :for_question, votable: question, user_id: user.id) }
        it_behaves_like "can't see question vote buttons"
      end
    end

    context 'user is author of question' do
      given!(:question) { create(:question, user_id: user.id) }
      it_behaves_like "can't see question vote buttons"
    end

  end

  context 'not signed in user' do
    given!(:question) { create(:question) }
    it_behaves_like "can't see question vote buttons"
  end
end
