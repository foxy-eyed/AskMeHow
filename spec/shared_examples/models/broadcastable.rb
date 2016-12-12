shared_examples_for 'broadcastable' do
  klass_name = described_class.to_s
  describe "#{klass_name} broadcasting" do
    subject { build(klass_name.underscore.to_sym) }

    let!(:job) { "#{klass_name.pluralize}BroadcastJob".constantize }

    it 'should broadcast object after create' do
      expect(job).to receive(:perform_later).with(subject)
      subject.save!
    end

    it 'should not broadcast object after update' do
      subject.save!
      expect(job).to_not receive(:perform_later)
      subject.update!(body: 'updated body')
    end
  end
end
