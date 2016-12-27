require 'feature_spec_helper'

feature 'Search', %q{
  In order to quickly find required information
  As a user
  I want to be able to search on website
} do

  given!(:question1) { create(:question, title: 'searchable question title') }
  given!(:question2) { create(:question, title: 'invisible question title') }

  given!(:answer1) { create(:answer, body: 'searchable answer body') }
  given!(:answer2) { create(:answer, body: 'invisible answer body') }

  given!(:question_comment) { create(:comment, commentable: question1, body: 'searchable question comment text') }
  given!(:answer_comment) { create(:comment, commentable: answer1, body: 'searchable answer comment text') }

  given!(:user) { create(:user, email: 'searchable@mail.com')}

  scenario 'when empty query', sphinx: true do
    index
    visit search_path
    click_button 'Search'
    expect(page).to have_content 'query can\'t be blank'
  end

  context 'when query in not empty' do
    before do
      index
      visit search_path
      fill_in 'Query', with: 'searchable'
    end

    scenario 'scope not given', sphinx: true do
      click_button 'Search'

      expect(page).to have_content question1.title
      expect(page).to have_content answer1.body
      expect(page).to have_content answer_comment.body
      expect(page).to have_content question_comment.body
      expect(page).to have_content user.email

      expect(page).to_not have_content question2.title
      expect(page).to_not have_content answer2.body
    end

    scenario 'searching for questions', sphinx: true do
      select 'questions', from: 'Scope'
      click_button 'Search'

      expect(page).to have_content question1.title

      expect(page).to_not have_content answer1.body
      expect(page).to_not have_content answer_comment.body
      expect(page).to_not have_content user.email
    end

    scenario 'searching for answers', sphinx: true do
      select 'answers', from: 'Scope'
      click_button 'Search'

      expect(page).to have_content answer1.body

      expect(page).to_not have_content question1.title
      expect(page).to_not have_content answer_comment.body
      expect(page).to_not have_content user.email
    end

    scenario 'searching for comments', sphinx: true do
      select 'comments', from: 'Scope'
      click_button 'Search'

      expect(page).to have_content answer_comment.body
      expect(page).to have_content question_comment.body

      expect(page).to_not have_content question1.title
      expect(page).to_not have_content answer1.body
      expect(page).to_not have_content user.email
    end

    scenario 'searching for users', sphinx: true do
      select 'users', from: 'Scope'
      click_button 'Search'

      expect(page).to have_content user.email

      expect(page).to_not have_content question1.title
      expect(page).to_not have_content answer1.body
      expect(page).to_not have_content answer_comment.body
    end
  end
end
