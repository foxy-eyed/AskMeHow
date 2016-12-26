require 'feature_spec_helper'

feature 'Search', %q{
  In order to quickly find required information
  As a user
  I want to be able to search on website
} do

  given!(:questions) { create_list(:question, 2) }
  given!(:question) { create(:question, title: 'irregular_title') }

  given!(:answers) { create_list(:answer, 2) }
  given!(:answer) { create(:question, title: 'irregular_body') }

  before do
    visit search_path
  end

  scenario 'searching for questions', sphinx: true do
    fill_in 'Query', with: 'question_title'
    select 'questions', from: 'Scope'
    click_on 'Search'

    questions.each do |q|
      expect(page).to have_content q.title
    end
    expect(page).to_not have_content 'irregular_title'
  end
end
