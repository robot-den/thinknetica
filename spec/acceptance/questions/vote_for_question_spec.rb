require "acceptance_helper"

feature 'user can vote for question', %q{
  In order to estimate question
  As an authenticated user
  I want to vote up or down for it
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user vote up, cancel vote and vote down', js: true do
    sign_in(user)
    visit question_path(question)

    within ".question .rating" do
      click_on 'up'

      expect(page).to have_content '1'
      # expect(page).to have_link 'cancel'
      # expect(page).to_not have_link 'up'
      # expect(page).to_not have_link 'down'

      click_on 'cancel'

      expect(page).to have_content '0'
      # expect(page).to_not have_link 'cancel'
      # expect(page).to have_link 'up'
      # expect(page).to have_link 'down'

      click_on 'down'

      expect(page).to have_content '-1'
      # expect(page).to have_link 'cancel'
      # expect(page).to_not have_link 'up'
      # expect(page).to_not have_link 'down'
    end
  end
  scenario "authenticated user vote for his own question", js: true do
    sign_in(user)
    question = create(:question, user: user)
    visit question_path(question)

    within ".question .rating" do
      expect(page).to have_content '0'
      expect(page).to_not have_link 'cancel'
      expect(page).to_not have_link 'up'
      expect(page).to_not have_link 'down'
    end
  end

  scenario 'non-authenticated user try vote', js: true do
    visit question_path(question)

    within ".question .rating" do
      expect(page).to have_content '0'
      expect(page).to_not have_link 'cancel'
      expect(page).to_not have_link 'up'
      expect(page).to_not have_link 'down'
    end
  end
end
