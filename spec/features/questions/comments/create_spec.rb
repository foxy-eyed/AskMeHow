require 'feature_spec_helper'

feature 'Add comment to question', %q{
  In order to clarify details about the question
  As an authenticated user
  I want to add comments
} do
  given(:user)      { create(:user) }
  given(:question)  { create(:question) }

  it_should_behave_like 'add comment ability' do
    let(:commentable) { question }
    let!(:commentable_path) { question_path(question) }
    let!(:commentable_container) { '.question' }
  end
end
