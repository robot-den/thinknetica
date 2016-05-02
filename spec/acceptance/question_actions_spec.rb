require 'rails_helper'

feature 'User can create question', %q{
  In order to be able to ask question
  As an User
  I want to be able create question
} do
  scenario 'User create question' do
    # User.create!(email: 'user@test.ru', password: '12345678', password_confirmation: '12345678')

    visit new_question_path
    fill_in 'Title', with: 'My question is'
    fill_in 'Body', with: 'I want to ask you about rails'
    click_on 'Submit'

    expect{ Question.find_by_title('My question is').count }.to eq 1
    expect(current_page).to eq question_path(assigns[:question])
  end
end
