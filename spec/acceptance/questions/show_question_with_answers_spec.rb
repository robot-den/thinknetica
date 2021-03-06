require 'acceptance_helper'

feature 'User can view question with its answers', %q{
  In order to interact with community
  As an user
  I want to read question with its answers
} do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'user view question with its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
