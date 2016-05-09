require 'acceptance_helper'

feature 'User can edit his answer', %q{
  In order to change inaccurate answer
  As an authenticated user
  I want to edit my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }

  scenario 'authenticated user edit his answer', js: true do
    sign_in(user)
    answer
    visit question_path(question)

    within '.answers' do
      click_on 'Edit answer'
      fill_in 'Answer', with: 'First edit answer'
      click_on 'Save'

      expect(page).to have_content 'First edit answer'
      expect(page).to_not have_content answer.body
      expect(page).to_not have_selector 'textarea'

      click_on 'Edit answer'
      fill_in 'Answer', with: 'Second edit answer'
      click_on 'Save'

      expect(page).to have_content 'Second edit answer'
      expect(page).to_not have_content 'First edit answer'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario "authenticated user edit another's answer", js: true do
    sign_in(user)
    create(:answer, question: question)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end

  scenario 'non-authenticated user edit answer', js: true do
    create(:answer, question: question)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end
end
