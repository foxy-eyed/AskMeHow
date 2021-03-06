require 'feature_spec_helper'

feature 'Vote question', %q{
  In order to show that the question is useful (or not)
  As an authenticated user
  I want to vote for it
} do
  given(:user)      { create(:user) }
  given(:question)  { create(:question) }

  it_should_behave_like 'vote ability' do
    let(:votable) { question }
    let!(:votable_path) { question_path(question) }
    let!(:votable_container) { '.question' }
  end
end
