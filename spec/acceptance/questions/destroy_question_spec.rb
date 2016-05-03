require 'rails_helper'

feature 'User can delete his question', %q{
  In order to remove unrelevant question
  As an authenticated user
  I want to delete question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user deletes his question' do
    sign_in(user)

    click_on 'Ask question'
    fill_in 'Title', with: 'My test question'
    fill_in 'Body', with: 'I want to ask you about rails'
    click_on 'Create Question'

    click_on 'Delete Question'

    expect(page).to have_content 'Your question deleted successfully'
    expect(current_path).to eq questions_path
  end

  scenario "authenticated user deletes another's question" do
    question
    sign_in(user)

    # Юзер вообще смог бы отправить такой запрос? Ведь у него нет подобной ссылки
    page.driver.submit :delete, "/questions/#{question.id}", {}

    expect(page).to have_content "You can't delete that question"
    expect(current_path).to eq question_path(question)
  end

  scenario 'non-authenticated user deletes question' do
    page.driver.submit :delete, "/questions/#{question.id}", {}

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
