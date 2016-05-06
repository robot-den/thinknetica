require 'acceptance_helper'

feature 'User can delete his answer', %q{
  In order to remove unrelevant answer
  As an authenticated user
  I want to delete answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'authenticated user deletes his answer' do
    sign_in(user)

    create(:answer, user: user, question: question)

    visit question_path(question)
    click_on 'Delete my answer'

    expect(page).to have_content 'Your answer deleted successfully'
  end

  scenario "authenticated user deletes another's answer" do
    sign_in(user)

    visit question_path(answer.question_id)

    expect(page).to_not have_link 'Delete my answer'
  end

  scenario 'non-authenticated user deletes answer' do
    visit question_path(answer.question_id)

    expect(page).to_not have_link 'Delete my answer'
  end
end
