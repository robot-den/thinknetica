require 'rails_helper'

feature 'User can create answers', %q{
  In order to help community
  As an authenticated user
  I want to create answers
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  # scenario 'authenticated user creates answer' do
  #   sign_in(user)
  #   visit question_path(question)
  #
  #   fill_in 'Answer', with: 'That is my answer'
  #   click_on 'Reply'
  #
  #   expect(page).to have_content 'That is my answer'
  # end

  scenario 'authenticated user creates answer via AJAX', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer', with: 'That is my answer'
    click_on 'Reply'

    within '.answers' do
      expect(page).to have_content 'That is my answer'
    end
  end

  scenario 'authenticated user try create invalid answer via AJAX', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer', with: 'My answer'
    click_on 'Reply'

    expect(page).to have_content 'Body is too short (minimum is 10 characters)'
  end

  scenario 'non-authenticated user creates answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Reply'
  end
end
