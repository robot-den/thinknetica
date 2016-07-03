require 'acceptance_helper'

feature 'User can remove files of answer', %q{
  In order to remove irrelevant files
  As an authenticated User
  I want to delete attachment files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, :with_attachment, question: question) }

  scenario "Authenticated user as author of answer remove answer's files", js: true do
    sign_in(user)
    answer = create(:answer, :with_attachment, user: user, question: question)
    visit question_path(question)

    within ".answers" do
      click_on 'remove file'

      expect(page).to_not have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"
      expect(page).to_not have_link('remove file')
    end
  end

  scenario "Authenticated user remove files of another's answer", js: true do
    sign_in(user)
    answer
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector(:css, "a#remove_file")
    end
  end

  scenario "Non-authenticated user remove answer's files", js: true do
    answer
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector(:css, "a#remove_file")
    end
  end
end
