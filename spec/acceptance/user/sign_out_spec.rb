require 'rails_helper'

feature 'User sign out', %q{
  In order to end session
  As an autheticated user
  I want to sign out
} do
  scenario 'authenticated user try to sign out' do
    User.create!(email: 'user@test.ru', password: '12345678', password_confirmation: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully'
    expect(current_path).to eq root_path
  end
end
