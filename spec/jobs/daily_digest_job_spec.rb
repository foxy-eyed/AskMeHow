require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  include ActiveJob::TestHelper

  let!(:users) { create_list(:user, 2) }
  let(:job) { DailyDigestJob.perform_now }

  context 'when new questions exist' do
    let!(:questions) { create_list(:yesterdays_question, 2, user: users.first) }

    it 'queues the mailer jobs' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(users.size)
    end

    it 'executes perform' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
      end
      job
    end
  end

  context 'when there is no new questions' do
    it 'does not queue the job' do
      expect { job }.to_not change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size)
    end

    it 'does not execute perform' do
      expect(DailyMailer).to_not receive(:digest)
      job
    end
  end
end
