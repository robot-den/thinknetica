require 'rails_helper'

feature 'User can view question with its answers', %q{
  In order to interact with community
  As an user
  I want to read question with its answers
} do
  given(:question) { create(:question) }

  scenario 'user view question with its answers' do
    question
    question.answers << Answer.new(body: 'MyText123456789')

    visit question_path(question)

    expect(page).to have_content 'MyTitle123456789'
    expect(page).to have_content 'MyBody123456789'
    expect(page).to have_content 'MyText123456789'
    expect(current_path).to eq question_path(question)
  end
end
