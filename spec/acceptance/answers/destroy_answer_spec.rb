require 'rails_helper'

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
    question.answers << Answer.new(body: 'ExampleText', user_id: user.id)

    visit question_path(question)
    click_on 'Delete my answer'

    expect(page).to have_content 'Your answer deleted successfully'
    expect(current_path).to eq question_path(question)
  end

  scenario "authenticated user deletes another's answer" do
    sign_in(user)

    page.driver.submit :delete, "/answers/#{answer.id}", {}

    expect(page).to have_content "You can't delete that answer"
    expect(current_path).to eq question_path(answer.question_id)
  end

  scenario 'non-authenticated user deletes answer' do
    page.driver.submit :delete, "/answers/#{answer.id}", {}

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
