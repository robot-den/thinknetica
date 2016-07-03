require 'acceptance_helper'

feature 'User can choose the best answer', %q{
  In order to indicate answer that solve my problem
  As an authenticated user
  I want to select best answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer_one) { create(:answer, question: question) }
  given!(:answer_two) { create(:answer, question: question) }

  scenario 'authenticated user as author of question set various answers as best', js: true do
    sign_in(user)
    visit question_path(question)

    within ".show-answer-links#answer-#{ answer_one.id }" do
      click_on 'mark as best'

      expect(page).to_not have_link 'mark as best'
      expect(page).to have_content 'Best answer'
    end

    within '.answers' do
      expect(page.first('div')[:id]).to eq "answer-#{answer_one.id}"
    end

    within ".show-answer-links#answer-#{ answer_two.id }" do
      click_on 'mark as best'

      expect(page).to_not have_link 'mark as best'
      expect(page).to have_content 'Best answer'
    end

    within '.answers' do
      expect(page.first('div')[:id]).to eq "answer-#{answer_two.id}"
    end

    within ".show-answer-links#answer-#{ answer_one.id }" do
      expect(page).to have_link 'mark as best'
      expect(page).to_not have_content 'Best answer'
    end

  end

  scenario "authenticated user set best answer for another's question", js: true do
    sign_in(user)
    question = create(:question)
    answer = create(:answer, question: question)
    visit question_path(question)

    within ".show-answer-links#answer-#{ answer.id }" do
      expect(page).to_not have_link 'mark as best'
    end
  end

  scenario 'non-authenticated user set best answer', js: true do
    question = create(:question)
    answer = create(:answer, question: question)
    visit question_path(question)

    within ".show-answer-links#answer-#{ answer.id }" do
      expect(page).to_not have_link 'mark as best'
    end
  end
end
