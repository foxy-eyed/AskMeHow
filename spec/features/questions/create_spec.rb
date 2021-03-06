require 'feature_spec_helper'

feature 'Create question', %q{
  In order to solve my problem with help of community
  As an authenticated user
  I want to ask a question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question with proper data' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    expect(current_path).to eq new_question_path

    data = attributes_for(:question)
    fill_in 'Title', with: data[:title]
    fill_in 'Body', with: data[:body]
    click_on 'Ask question'

    expect(page).to have_content data[:title]
    expect(page).to have_content data[:body]
    within '.alert-success' do
      expect(page).to have_content 'Question was successfully created.'
    end
    expect(current_path).to match /^\/questions\/\d+$/
  end

  scenario 'Authenticated user tries to create question with invalid data' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    expect(current_path).to eq new_question_path

    data = attributes_for(:invalid_question)
    fill_in 'Title', with: data[:title]
    fill_in 'Body', with: data[:body]
    click_on 'Ask question'

    within '.alert-danger' do
      expect(page).to have_content 'Errors prohibited this record from being saved:'
      expect(page).to have_content 'title can\'t be blank'
      expect(page).to have_content 'body can\'t be blank'
    end
    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end


  scenario 'All users see new questions in real-time', js: true do
    data = attributes_for(:question)

    Capybara.using_session('author') do
      sign_in(user)
      visit questions_path
    end

    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('author') do
      click_on 'Ask question'

      fill_in 'Title', with: data[:title]
      fill_in 'Body', with: data[:body]
      click_on 'Ask question'

      expect(page).to have_content data[:title]
      expect(page).to have_content data[:body]
    end

    Capybara.using_session('guest') do
      expect(page).to have_content data[:title]
    end
  end

end
