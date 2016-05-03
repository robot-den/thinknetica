require 'rails_helper'

feature 'User try to sign up', %q{
  In order to interact with community
  As an unregistered user
  I want to sign up
} do
  scenario 'user try to sign up with correct data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(User.count).to eq 1
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'user try to sign up with email that already exist' do
    User.create!(email: 'user@test.ru', password: '12345678', password_confirmation: '12345678')
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(User.count).to eq 1
    expect(page).to have_content 'Email has already been taken'
    # Devise после неудачной регистрации редиректит на /users
    # expect(current_path).to eq new_user_registration_path
  end
end
