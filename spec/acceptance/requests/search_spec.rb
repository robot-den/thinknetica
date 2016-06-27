require 'sphinx_helper'

feature 'User can search',  %{
  In order to find necessary information
  As an user
  I want to use search
} do
  given!(:relevant_question) { create(:question, title: 'question sphinx search') }
  given!(:unrelevant_question) { create(:question) }
  given!(:relevant_answer) { create(:answer, body: 'answer sphinx search') }
  given!(:unrelevant_answer) { create(:answer) }
  given!(:relevant_comment) { create(:comment, body: 'comment sphinx search') }
  given!(:unrelevant_comment) { create(:comment) }
  given!(:relevant_user) { create(:user, email: 'sphinx@test.com') }
  given!(:unrelevant_user) { create(:user) }

  background do
    index
  end

  scenario 'User search by questions', sphinx: true, js: true do
    visit root_path

    fill_in 'search', with: 'sphinx'
    page.select 'questions', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_question.title
    expect(page).to_not have_content unrelevant_question.title
  end

  scenario 'User search by answers', sphinx: true, js: true do
    visit root_path

    fill_in 'search', with: 'sphinx'
    page.select 'answers', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_answer.body
    expect(page).to_not have_content unrelevant_answer.body
  end

  scenario 'User search by comments', sphinx: true, js: true do
    visit root_path

    fill_in 'search', with: 'sphinx'
    page.select 'comments', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_comment.body
    expect(page).to_not have_content unrelevant_comment.body
  end

  scenario 'User search by users', sphinx: true, js: true do
    visit root_path

    fill_in 'search', with: 'sphinx@test.com'
    page.select 'users', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_user.email
    expect(page).to_not have_content unrelevant_user.email
  end

  scenario 'User search by everywhere', sphinx: true, js: true do
    visit root_path

    fill_in 'search', with: 'sphinx'
    page.select 'everywhere', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_question.title
    expect(page).to have_content relevant_answer.body
    expect(page).to have_content relevant_comment.body
    expect(page).to have_content relevant_user.email
    expect(page).to_not have_content unrelevant_question.title
    expect(page).to_not have_content unrelevant_answer.body
    expect(page).to_not have_content unrelevant_comment.body
    expect(page).to_not have_content unrelevant_user.email
  end

  scenario 'user find nothing', sphinx: true, js: true do
    visit root_path

    fill_in 'search', with: 'nothing'
    page.select 'everywhere', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content 'Omg! You find nothing!'
  end
end
