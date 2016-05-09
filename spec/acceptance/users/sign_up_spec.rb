require 'acceptance_helper'

feature 'User sign up', %q{
  In order to interact with community
  As an unregistered user
  I want to sign up
} do
  scenario 'user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(User.count).to eq 1
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
