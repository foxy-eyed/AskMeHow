require 'feature_spec_helper'

feature 'Cancel subscription', %q{
  In order to stop following a question
  As a subscriber
  I want to unsubscribe
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Subscribed user' do
    given!(:subscription) { create(:subscription, question: question, user: user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see "unsubscribe" button' do
      within '.button-bar' do
        expect(page).to have_link 'Unsubscribe'
      end
    end

    scenario 'can unsubscribe a question', js: true do
      within '.button-bar' do
        click_on 'Unsubscribe'
        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end
  end

  context 'Not subscribed user' do
    scenario 'can not see "unsubscribe" button' do
      sign_in(user)
      visit question_path(question)

      within '.button-bar' do
        expect(page).to_not have_link 'Unsubscribe'
      end
    end

    scenario 'does not get email when someone answers a question', js: true do
      clear_emails

      sign_in(create(:user))
      visit question_path(question)
      fill_in 'Your answer', with: 'New clever answer'
      click_on 'Add answer'
      wait_for_ajax

      expect(emails_sent_to(user.email)).to be_empty
    end
  end
end
