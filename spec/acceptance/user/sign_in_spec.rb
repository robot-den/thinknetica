require 'rails_helper'

feature 'User sign in', %q{
  In order to interact with community
  As an user
  I want to sign in
} do
  scenario 'registered user try to sign in' do
    User.create!(email: 'user@test.ru', password: '12345678', password_confirmation: '12345678')
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

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
