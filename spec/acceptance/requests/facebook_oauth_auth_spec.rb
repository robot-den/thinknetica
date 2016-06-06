require 'acceptance_helper'

feature 'User can login with facebook', %q{
  In order to sign in system
  As an non-authenticated user
  I want to login with facebook
} do
  scenario 'user try to log in with valid data' do
    visit new_user_session_path
    mock_auth_valid_hash('facebook', 'test@test.com')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Log out'
  end

  scenario 'user try to log in with invalid data' do
    visit new_user_session_path

    mock_auth_invalid_hash('facebook')

    click_on 'Sign in with Facebook'

    expect(page).to have_content('Could not authenticate you from Facebook')
  end
end
