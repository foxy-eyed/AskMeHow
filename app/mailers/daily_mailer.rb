class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @user = user
    @questions = questions
    mail(to: @user.email, subject: 'Daily digest')
  end
end
