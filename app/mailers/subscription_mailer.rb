class SubscriptionMailer < ApplicationMailer
  def notify(user, answer)
    @user = user
    @answer = answer
    mail(to: @user.email, subject: 'New answer to question you subscribed')
  end
end
