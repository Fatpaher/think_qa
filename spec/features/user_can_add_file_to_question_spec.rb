require 'rails_helper'

feature 'can add files to question' do
  given(:user) { create(:user) }
  given(:question) { attributes_for(:question) }

  background do
    sign_in user
    visit new_question_path
    fill_in 'Title', with: question[:title]
    fill_in 'Body', with: question[:body]
  end

  scenario 'user can add file when create question', js:true do
    attach_file('File', "#{Rails.root}/spec/files/test.txt")
    click_on('Create Question')

    expect(page).to have_link('test.txt')
  end

  scenario 'user can add few files to question', js: true do
    attach_file('File', "#{Rails.root}/spec/files/test.txt")
    click_on('Add File')
    within page.all('.file-form').last do
      attach_file('File', "#{Rails.root}/spec/files/test.txt")
    end
    click_on 'Create Question'

    expect(page).to have_link('test.txt', count: 2)
  end
end
