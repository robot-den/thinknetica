require 'rails_helper'

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

    # Нужно ли проверять количество созданных записей?
    expect(Question.where(title: 'My test question').count).to eq 1

    expect(page).to have_content 'Your question created successfully'
    expect(page).to have_content 'My test question'

    # Как тут лучше получить ID вопроса, чтобы проверить путь?
    expect(current_path).to eq question_path(Question.find_by_title('My test question'))
  end

  scenario 'non-authenticated user creates question' do
    visit new_question_path

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
