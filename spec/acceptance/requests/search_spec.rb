require 'acceptance_helper'

feature 'User can search on the resource', %{
  In order to find necessary information
  As an user
  I want to use search
} do
  let!(:relevant_question) { create(:question, title: 'question sphinx search') }
  let!(:unrelevant_question) { create(:question) }
  let!(:relevant_answer) { create(:answer, body: 'answer sphinx search') }
  let!(:unrelevant_answer) { create(:answer) }
  let!(:relevant_comment) { create(:comment, body: 'comment sphinx search') }
  let!(:unrelevant_comment) { create(:comment) }
  let!(:relevant_user) { create(:user, email: 'sphinx@test.com') }
  let!(:unrelevant_user) { create(:user) }

  scenario 'User search by questions' do
    visit root_path

    fill_in 'search', with: 'sphinx'
    page.select 'questions', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_question.title
    expect(page).to_not have_content unrelevant_question.title
  end

  scenario 'User search by answers' do
    visit root_path

    fill_in 'search', with: 'sphinx'
    page.select 'answers', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_answer.body
    expect(page).to_not have_content unrelevant_answer.body
  end

  scenario 'User search by comments' do
    visit root_path

    fill_in 'search', with: 'sphinx'
    page.select 'comments', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_comment.body
    expect(page).to_not have_content unrelevant_comment.body
  end

  scenario 'User search by users' do
    visit root_path

    fill_in 'search', with: 'sphinx@test.com'
    page.select 'users', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_user.email
    expect(page).to_not have_content unrelevant_user.email
  end

  scenario 'User search everywhere' do
    visit root_path

    fill_in 'search', with: 'sphinx@test.com'
    page.select 'everywhere', from: 'search_by'
    click_on 'Find'

    expect(page).to have_content relevant_user.email
    expect(page).to_not have_content unrelevant_user.email
  end
end
