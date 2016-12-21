require 'rails_helper'

RSpec.describe AnswersNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { AnswersNotificationJob.perform_now(answer) }

  context 'when subscriber is not an author of answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:subscriptions) { create_list(:subscription, 2, question: question) }

    it 'queues the mailer jobs' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(question.subscriptions.size)
    end

    it 'performs job' do
      question.subscriptions.each do |subscription|
        expect(SubscriptionMailer).to receive(:notify).with(subscription.user, answer).and_call_original
      end
      job
    end
  end

  context 'when subscriber is an author of answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: question.user) }

    it 'does not queue the job' do
      expect { job }.to_not change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size)
    end

    it 'does not perform job' do
      expect(SubscriptionMailer).to_not receive(:notify)
      job
    end
  end
end
