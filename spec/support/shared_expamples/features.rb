shared_examples "can't see question vote buttons" do
  scenario "can't vote for question" do
    visit question_path(question)
    expect(page).not_to have_css('.vote-up-button')
    expect(page).not_to have_css('.vote-down-button')
  end
end

shared_examples "can't see answer vote buttons" do
  scenario "can't vote for answer" do
    visit question_path(question)
    within '.answers' do
      expect(page).not_to have_css('.vote-up-button')
      expect(page).not_to have_css('.vote-down-button')
    end
  end
end
