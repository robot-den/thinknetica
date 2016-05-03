require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As an user
  I want to be able create question
} do
  scenario 'User creates question' do
    visit new_question_path
    fill_in 'Title', with: 'My test question'
    fill_in 'Body', with: 'I want to ask you about rails'
    click_on 'Create Question'

    expect(Question.where(title: 'My test question').count).to eq 1
    expect(page).to have_content 'Your question created successfully'

    # Как тут лучше получить ID вопроса, чтобы проверить путь?
    expect(current_path).to eq question_path(Question.find_by_title('My test question'))
  end
end
