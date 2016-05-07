require 'acceptance_helper'

feature 'User can edit his question', %q{
  In order to change inaccurate question
  As an authenticated user
  I want to edit my question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user edit his question', js: true do
    sign_in(user)
    question = create(:question, user: user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit question'
      fill_in 'Edit title', with: 'First edit title'
      fill_in 'Edit body', with: 'First edit body'
      click_on 'Save'

      expect(page).to_not have_content(question.title)
      expect(page).to_not have_content(question.body)
      expect(page).to have_content 'First edit title'
      expect(page).to have_content 'First edit body'
      expect(page).to_not have_selector 'textarea'

      click_on 'Edit question'
      fill_in 'Edit title', with: 'Second edit title'
      fill_in 'Edit body', with: 'Second edit body'
      click_on 'Save'

      expect(page).to_not have_content 'First edit title'
      expect(page).to_not have_content 'First edit body'
      expect(page).to have_content 'Second edit title'
      expect(page).to have_content 'Second edit body'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario "authenticated user edit another's question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit question'
    end
  end

  scenario 'non-authenticated user edit answer', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit question'
    end
  end
end
