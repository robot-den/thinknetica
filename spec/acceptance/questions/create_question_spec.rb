require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As an user
  I want to be able create question
} do
  scenario 'Authenticate user creates question' do
    User.create!(email: 'user@test.ru', password: '12345678', password_confirmation: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    click_on 'Ask question'
    fill_in 'Title', with: 'My test question'
    fill_in 'Body', with: 'I want to ask you about rails'
    click_on 'Create Question'

    expect(Question.where(title: 'My test question').count).to eq 1
    expect(page).to have_content 'Your question created successfully'

    # Как тут лучше получить ID вопроса, чтобы проверить путь?
    expect(current_path).to eq question_path(Question.find_by_title('My test question'))
  end

  scenario 'Non-authenticate user creates question' do
    visit new_question_path

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
