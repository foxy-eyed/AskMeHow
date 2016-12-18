require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list(:user, 2) }
  let!(:job) { DailyDigestJob.perform_now }

  context 'when new questions exist' do
    let!(:questions) { create_list(:yesterdays_question, 2) }

    it 'queues the job' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(users.size)
    end

    it 'executes perform' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
      end
      job
    end
  end
end
