require 'acceptance_helper'

feature 'User can remove files of question', %q{
  In order to remove irrelevant files
  As an authenticated User
  I want to delete attachment files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_attachment) }

  scenario "Authenticated user as author of question remove question's files", js: true do
    sign_in(user)
    question = create(:question, :with_attachment, user: user)
    visit question_path(question)
    within '.question' do
      click_on 'remove file'

      expect(page).to_not have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"
      expect(page).to_not have_link 'remove file'
    end
  end

  scenario "Authenticated user remove files of another's question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'remove file'
    end
  end

  scenario "Non-authenticated user remove question's files", js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'remove file'
    end
  end
end
