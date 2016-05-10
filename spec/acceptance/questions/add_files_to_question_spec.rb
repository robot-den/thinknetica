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

  scenario 'autheticated user create question with files', js: true do
    fill_in 'Title', with: 'My test question'
    fill_in 'Body', with: 'I want to ask you about rails'

    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Create Question'

    expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"
    expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/2/spec_helper.rb"
  end

end
