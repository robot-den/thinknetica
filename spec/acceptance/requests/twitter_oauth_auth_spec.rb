require 'acceptance_helper'
require 'capybara/email/rspec'

feature 'User can login with twitter', %q{
  In order to sign in system
  As an non-authenticated user
  I want to login with twitter
} do
  scenario 'user try to log in with valid data' do
    visit new_user_session_path
    mock_auth_valid_hash('twitter', nil)

    clear_emails
    click_on 'Sign in with Twitter'
    fill_in 'Enter your email', with: 'test@test.com'
    click_on 'Send'
    expect(page).to have_content 'Now you need to confirm your email'

    open_email('test@test.com')
    current_email.click_link 'Confirm my email'

    expect(page).to have_content 'Log out'

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'

    click_on 'Sign in'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Log out'
  end

  scenario 'user try to log in with invalid data' do
    visit new_user_session_path

    mock_auth_invalid_hash('twitter')
    click_on 'Sign in with Twitter'

    expect(page).to have_content('Could not authenticate you from Twitter')
  end
end
