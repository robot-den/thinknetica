require 'acceptance_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to create question
} do
  given(:user) { create(:user) }

  scenario 'authenticated user creates question' do
    sign_in(user)

    click_on 'Ask question'
    fill_in 'Title', with: 'My test question'
    fill_in 'Body', with: 'I want to ask you about rails'
    click_on 'Create Question'

    expect(page).to have_content 'Your question created successfully'
    expect(page).to have_content 'My test question'
    expect(page).to have_content 'I want to ask you about rails'
  end

  scenario 'non-authenticated user creates question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end
