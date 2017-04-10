require 'rails_helper'

feature 'user can subscribe to question' do
  given(:question) { create :question}
  context 'authenticated user' do
    given(:user) { create :user }

    scenario 'user subscribe to question', js: true do
      sign_in user
      visit question_path question
      click_on 'Subscribe'

      expect(page).to have_content 'Unsubscribe'
    end
  end

  context 'not authenticated user' do
    it "can't see subscribe buttons" do
      visit question_path(question)

      expect(page).not_to have_content 'Subscribe'
    end
  end
end
