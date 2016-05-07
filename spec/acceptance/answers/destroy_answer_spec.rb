require 'acceptance_helper'

feature 'User can delete his answer', %q{
  In order to remove unrelevant answer
  As an authenticated user
  I want to delete answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'authenticated user deletes his answer', js: true do
    sign_in(user)
    answer = create(:answer, user: user, question: question)

    visit question_path(question)
    within '.answers' do
      click_on 'Delete my answer'
      
      expect(page).to_not have_content answer.body
    end
  end

  scenario "authenticated user deletes another's answer", js: true do
    sign_in(user)
    visit question_path(answer.question_id)

    within '.answers' do
      expect(page).to_not have_link 'Delete my answer'
    end
  end

  scenario 'non-authenticated user deletes answer', js: true do
    visit question_path(answer.question_id)

    within '.answers' do
      expect(page).to_not have_link 'Delete my answer'
    end
  end
end
