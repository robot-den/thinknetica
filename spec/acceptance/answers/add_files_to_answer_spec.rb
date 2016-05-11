require 'acceptance_helper'

feature 'User can attach files to answer', %q{
  In order to illustrate my answer
  As an authenticated User
  I want to add files to answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'autheticated user create answer with files', js: true do
    fill_in 'Answer', with: 'That is my answer'

    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Reply'

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"
      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/2/spec_helper.rb"
    end
  end

end
