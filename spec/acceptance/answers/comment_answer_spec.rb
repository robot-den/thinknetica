require "acceptance_helper"

feature 'user can comment answer', %q{
  In order to discuss answer
  As an authenticated user
  I want to add comments to answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'authenticated user comment answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id} .new-answer-comment" do
      click_on 'comment'
    end

    within "#answer-#{ answer.id }-comments" do
      fill_in 'Comment', with: 'My comment'
      click_on 'Send'

      expect(page).to have_content 'My comment'
    end
  end

  scenario 'non-authenticated user try comment', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'add comment'
  end
end
