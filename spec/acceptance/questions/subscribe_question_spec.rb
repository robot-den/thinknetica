require "acceptance_helper"

feature 'user can subscribe question', %q{
  In order to take notice when question takes new answers
  As an authenticated user
  I want to subscribe question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  scenario 'authenticated user subscribe/unsubscribe question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question .subscription' do
      click_on 'subscribe'
      expect(page).to have_link 'unsubscribe'
      expect(page).to_not have_link ' subscribe'
      click_on 'unsubscribe'
      expect(page).to have_link 'subscribe'
      expect(page).to_not have_link 'unsubscribe'
    end
  end

  scenario 'author of the question already have subscription' do
    sign_in(user)
    visit question_path(user_question)

    within '.question .subscription' do
      expect(page).to have_link 'unsubscribe'
    end
  end

  scenario 'non-authenticated user try subscribe', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'subscribe'
  end
end
