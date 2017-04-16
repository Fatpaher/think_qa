require 'rails_helper'

feature 'User can search everywhere' do
  context 'in location' do
    given!(:user) { create :user }
    given!(:question) { create :question }
    given!(:answer) { create :answer }
    given!(:comment) { create :comment }

    scenario 'with invalid query', sphinx: true do
      visit search_index_path

      fill_in 'Search for', with: 'Foobar'
      select 'Users', from: 'In'
      click_on 'Find'

      expect(page).not_to have_content(user.email)
      expect(page).not_to have_content(question.title)
      [question, answer, comment].each do |object|
        expect(page).not_to have_content(object.body)
      end
    end

    scenario 'in questions', sphinx: true do
      visit search_index_path
      fill_in 'Search for', with: question.title
      select 'Questions', from: 'In'
      click_on 'Find'

      expect(page).to have_content(question.title)
    end

    scenario 'in answers', sphinx: true do
      visit search_index_path
      fill_in 'Search for', with: answer.body
      select 'Answers', from: 'In'
      click_on 'Find'

      expect(page).to have_content(answer.body)
    end

    scenario 'in comments', sphinx: true do
      visit search_index_path
      fill_in 'Search for', with: comment.body
      select 'Comments', from: 'In'
      click_on 'Find'

      expect(page).to have_content(comment.body)
    end

    scenario 'in users', sphinx: true do
      visit search_index_path
      fill_in 'Search for', with: user.email
      select 'Users', from: 'In'
      click_on 'Find'

      expect(page).to have_content(user.email)
    end
  end

  context 'everywhere', sphinx: true do
    given!(:question) { create(:question, title: 'everywhere question') }
    given!(:answer) { create(:answer, body: 'everywhere answer') }
    given!(:comment) { create(:comment, body: 'everywhere comment') }
    given!(:user) { create(:user, email: 'everywhere@example.con') }

    scenario 'search' do
      visit search_index_path
      fill_in 'Search for', with: 'everywhere'
      select 'Everywhere', from: 'In'
      click_on 'Find'

      expect(page).to have_content(question.title)
      expect(page).to have_content(answer.body)
      expect(page).to have_content(comment.body)
      expect(page).to have_content(user.email)
    end
  end
end
