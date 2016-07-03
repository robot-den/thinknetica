require "acceptance_helper"

feature 'user can comment question', %q{
  In order to discuss question
  As an authenticated user
  I want to add comments to question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user comment question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question .new-question-comment' do
      click_on 'comment'
    end
    within '.question-comments' do
      fill_in 'Comment', with: 'My comment'
      click_on 'Send'

      expect(page).to have_content 'My comment'
    end
  end

  scenario 'non-authenticated user try comment', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'comment'
  end
end
