require 'acceptance_helper'

feature 'User can login with facebook', %q{
  In order to sign in system
  As an non-authenticated user
  I want to login with facebook
} do

  scenario 'user try to login with valid data' do
    visit new_user_session_path

    # ВЫНЕСТИ в МАКРОСЫ !
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => 'test@test.com'
      }
    })

    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Log out'
  end

  scenario 'user try to login with invalid data' do
    visit new_user_session_path

    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

    click_on 'Sign in with Facebook'

    expect(page).to have_content('Could not authenticate you from Facebook')
  end
end
