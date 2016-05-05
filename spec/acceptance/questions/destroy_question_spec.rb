require 'rails_helper'

feature 'User can delete his question', %q{
  In order to remove unrelevant question
  As an authenticated user
  I want to delete question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user deletes his question' do
    sign_in(user)

    click_on 'Ask question'
    fill_in 'Title', with: 'My test question'
    fill_in 'Body', with: 'I want to ask you about rails'
    click_on 'Create Question'

    click_on 'Delete Question'

    expect(page).to have_content 'Your question deleted successfully'
  end

  scenario "authenticated user deletes another's question" do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete Question'
  end

  scenario 'non-authenticated user deletes question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete Question'
  end
end
