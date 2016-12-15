require 'feature_spec_helper'

feature 'Daily digest', %q{
  In order to be informed about new questions
  As a user
  I want to receive daily digest via email
} do
  given!(:users) { create_list(:user, 2) }
  given!(:questions) { create_list(:question, 2) }
  given(:user) { users.first }
  given(:question) { questions.first }

  scenario 'All users receive email with questions' do
    clear_emails
    users.each do |user|
      DailyMailer.digest(user, questions).deliver_now
      open_email(user.email)

      questions.each do |question|
        expect(current_email).to have_link(question.title)
      end
    end
  end

  scenario 'User can click link and visit question page' do
    clear_emails
    DailyMailer.digest(user, questions).deliver_now
    open_email(user.email)

    current_email.click_link(question.title)
    expect(current_path).to eq question_path(question)
  end
end