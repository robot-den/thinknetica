require 'acceptance_helper'

feature 'User can vote up or down for questions', %q{
  In order to evaluate the usefulness
  As an authenticated User
  I want to vote for question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario "vote up/down for another's question" do
    sign_in(user)
    visit question_path(question)

    within '.question .rating' do
      click_on 'vote_up'
      expect(page).to have_content '1'
      expect(page).to have_css("a.vote_up.disabled")

      click_on 'vote_down'
      expect(page).to have_content '0'

      click_on 'vote_down'
      expect(page).to have_content '-1'
      expect(page).to have_css("a.vote_down.disabled")

      click_on 'vote_up'
      expect(page).to have_content '0'
    end
  end

  scenario "vote for his own question" do
    sign_in(user)
    question = create(:question, user: user)
    visit question_path(question)

    within '.question .rating' do
      expect(page).to have_content '0'
      expect(page).to_not have_link 'vote_up'
      expect(page).to_not have_link 'vote_down'
    end
  end

  scenario 'non-authenticated user try to vote for answer' do
    visit question_path(question)

    within '.question .rating' do
      expect(page).to have_content '0'
      expect(page).to_not have_link 'vote_up'
      expect(page).to_not have_link 'vote_down'
    end
  end
end
