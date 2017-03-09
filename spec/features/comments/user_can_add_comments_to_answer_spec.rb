require 'rails_helper'

feature 'user can add coment to answer' do
  given(:question){ create(:question) }
  given!(:answer){ create(:answer, question: question) }

  context 'sign in' do
    given(:user){ create(:user) }
    given(:comment){ attributes_for(:comment) }
    given(:invalid_comment){ attributes_for(:comment, :invalid) }

    background { sign_in user }

    scenario 'with valid attributes', js: true do
      visit question_path(question)
      within '.answer-comments' do
        click_on 'Add comment'
        fill_in 'Comment', with: comment[:body]
        click_on 'Add'

        expect(page).to have_content(comment[:body])
      end
    end

    scenario 'with invalid attributes', js: true do
      visit question_path(question)
      within '.answer-comments' do
        click_on 'Add comment'
        fill_in 'Comment', with: comment[:body]
        click_on 'Add'

        expect(page).to have_content(comment[:body])
      end
    end

    context 'multiple sessioin', js: true do
      scenario 'comment appears in other sessions' do
        Capybara.using_session('user') do
          sign_in user
          visit question_path(question)
        end
        Capybara.using_session('guest') do
          visit question_path(question)
        end
        Capybara.using_session('user') do
          within '.answer-comments' do
            click_on 'Add comment'
            fill_in 'Comment', with: comment[:body]
            click_on 'Add'
          end
        end
        Capybara.using_session('guest') do
          within '.answer-comments' do
            expect(page).to have_content(comment[:body])
          end
        end
      end
    end
  end

  context 'not signed in' do
    scenario "can't add comment" do
      visit question_path(question)
      within '.answer-comments' do
        expect(page).not_to have_content('Add comment')
      end
    end
  end
end
