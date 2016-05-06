require 'acceptance_helper'

feature 'User sign in', %q{
  In order to interact with community
  As an user
  I want to sign in
} do
  given(:user) { create(:user) }

  scenario 'registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'unregistered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end
