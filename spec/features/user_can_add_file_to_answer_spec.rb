require 'rails_helper'

feature 'can add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { attributes_for(:answer) }
  background do
    sign_in user
    visit question_path(question)
    fill_in 'Your Answer', with: answer[:body]
  end

  scenario 'user can add file when create answer', js:true do
    attach_file 'File', "#{Rails.root}/spec/files/test.txt"
    click_on 'Post Answer'

    within '.answers' do
      expect(page).to have_link 'test.txt'
    end
  end

  scenario 'user can add few files to asnwer', js: true do
    attach_file 'File', "#{Rails.root}/spec/files/test.txt"
    click_on('Add File')
    within page.all('.file-form').last do
      attach_file('File', "#{Rails.root}/spec/files/test.txt")
    end
    click_on 'Post Answer'

    expect(page).to have_link('test.txt', count: 2)
  end

  context 'multiple session', js: true do
    scenario 'attachments appears in other sessions' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your Answer', with: answer[:body]
        attach_file 'File', "#{Rails.root}/spec/files/test.txt"
        click_on 'Post Answer'
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_link 'test.txt'
        end
      end
    end
  end
end
