require 'feature_spec_helper'

feature 'Subscription', %q{
  In order to be informed about new answers via email
  As a user
  I want to subscribe to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see "subscribe" button' do
      within '.button-bar' do
        expect(page).to have_link 'Subscribe'
      end
    end

    scenario 'can subscribe a question', js: true do
      within '.button-bar' do
        click_on 'Subscribe'
        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end
  end

  context 'Subscribed user' do
    given!(:subscription) { create(:subscription, question: question, user: user) }
    given(:adviser) { create(:user) }

    scenario 'gets email when someone answers a question', js: true do
      clear_emails

      sign_in(adviser)
      visit question_path(question)
      fill_in 'Your answer', with: 'New clever answer'
      click_on 'Add answer'
      wait_for_ajax

      open_email(user.email)
      expect(current_email).to have_content 'New clever answer'
    end
  end

  context 'Non-authenticated user' do
    scenario 'can not see "subscribe" button' do
      visit question_path(question)

      within '.button-bar' do
        expect(page).to_not have_link 'Subscribe'
      end
    end
  end
end
