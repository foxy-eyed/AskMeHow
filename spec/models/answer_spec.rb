require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_should_behave_like 'attachable'
  it_should_behave_like 'votable'
  it_should_behave_like 'commentable'
  it_should_behave_like 'broadcastable'

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }

  context 'when answer accepted' do
    subject { create(:accepted_answer) }
    it { should validate_uniqueness_of(:accepted).scoped_to(:question_id) }
  end

  context 'when answer is not accepted' do
    subject { create(:answer) }
    it { should_not validate_uniqueness_of(:accepted) }
  end

  describe '#accept' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:accepted_answer) { create(:accepted_answer, question: question) }
    let!(:answer_to_accept) { create(:answer, question: question) }

    it 'changes accepted answer' do
      answer_to_accept.accept

      expect(answer_to_accept.reload).to be_accepted
      expect(accepted_answer.reload).to_not be_accepted
    end
  end

  describe 'Send notifications after create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    subject { build(:answer, question: question) }

    it 'should push notification job to queue after answer create' do
      expect(AnswersNotificationJob).to receive(:perform_later)
      subject.save!
    end

    it 'should not create job after update' do
      subject.save!
      expect(AnswersNotificationJob).to_not receive(:perform_later)
      subject.update!(body: 'updated body')
    end
  end
end
