class DailyDigestJob < ApplicationJob
  queue_as :default

  before_perform do |job|
    prepare_digest
  end

  def perform
    return if @questions.empty?

    User.find_each do |user|
      DailyMailer.digest(user, @questions).deliver_now
    end
  end

  private

  def prepare_digest
    midnight = Time.now.utc.midnight
    @questions = Question.where(created_at: (midnight - 1.day..midnight)).to_a
  end
end
