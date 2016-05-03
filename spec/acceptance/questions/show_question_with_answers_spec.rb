require 'rails_helper'

feature 'User can view question with its answers', %q{
  In order to interact with community
  As an user
  I want to read question with its answers
} do
  given(:question) { create(:question) }

  scenario 'user view question with its answers' do
    question.answers << Answer.new(body: 'It is my answer')

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'It is my answer'
    expect(current_path).to eq question_path(question)
  end
end
