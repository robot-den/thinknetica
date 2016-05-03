require 'rails_helper'

feature 'User can create answers', %q{
  In order to help community
  As an authenticate user
  I want to create answers
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'authenticate user creates answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Answer', with: 'That is my answer'
    click_on 'Reply'

    expect(question.answers.count).to eq 1
    expect(page).to have_content 'That is my answer'
    expect(current_path).to eq question_path(question)
  end

  scenario 'non-authenticate user creates answer' do
    visit question_path(question)
    fill_in 'Answer', with: 'That is my answer'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
