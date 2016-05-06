require 'acceptance_helper'

feature 'User can view a list of questions', %q{
  In order to select needed question
  As an user
  I want to view a list of questions
} do
  scenario 'User view a list of questions' do
    question = create(:question)

    visit questions_path

    expect(page).to have_content question.title
    expect(page).to have_link('Read', href: question_path(question))
  end
end
