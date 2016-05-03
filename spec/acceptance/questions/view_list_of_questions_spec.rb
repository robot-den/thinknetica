require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to be able to select needed question
  As an user
  I want to be able to view a list of questions
} do
  given(:question) { create(:question) }

  scenario 'User view a list of questions' do
    question

    visit questions_path

    expect(page).to have_content 'MyTitle123456789'
    expect(page).to have_link('Read', href: question_path(question))
  end
end
