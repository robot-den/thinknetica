require 'rails_helper'

feature 'User can create answers', %q{
  In order to help community
  As an user
  I want to be able to create answers
} do
  given(:question) { create(:question) }

  scenario 'user creates answer' do

    visit question_path(question)
    fill_in 'Answer', with: 'That is my answer'
    click_on 'Reply'

    expect(page).to have_content 'That is my answer'
    expect(current_path).to eq question_path(question)
  end
end
