require 'acceptance_helper'

feature 'User can attach files to question', %q{
  In order to illustrate my question
  As an authenticated User
  I want to add files to question
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'autheticated user create question with files' do
    fill_in 'Title', with: 'My test question'
    fill_in 'Body', with: 'I want to ask you about rails'
    attach_file 'File', "#{Rails.root}/spec/acceptance_macros.rb"
    click_on 'Create Question'

    expect(page).to have_content 'acceptance_macros.rb'
  end

end
