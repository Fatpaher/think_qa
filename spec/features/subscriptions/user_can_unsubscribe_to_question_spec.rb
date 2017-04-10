require 'rails_helper'

feature 'user can _unsubscribe.html.slim to question' do
  given!(:question) { create :question }

  context 'authenticated user' do
    given(:user) { create :user }
    given!(:subscription) { create :subscription, user: user, question: question}

    scenario 'user subscribe to question', js: true do
      sign_in user
      visit question_path question
      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
    end
  end

  context 'not authenticated user' do
    it "can't see _unsubscribe.html.slim buttons" do
      visit question_path(question)

      expect(page).not_to have_content 'Unsubscribe'
    end
  end
end
