require 'rails_helper'

RSpec.describe Search, type: :model do
  it { should validate_presence_of(:query) }

  describe '#run' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:search) { Search.new(query: user.email) }
    let!(:query) { ThinkingSphinx::Query.escape(search.query) }

    it 'global search when scope not defined' do
      expect(ThinkingSphinx).to receive(:search).with(query)
      search.run
    end

    it 'searches for specific models when scope defined' do
      search.scope = 'questions'
      expect(Question).to receive(:search).with(query)
      search.run
    end

    it 'stores search results in @result' do
      allow(ThinkingSphinx).to receive(:search).and_return([question])
      search.run
      expect(search.result).to eq([question])
    end
  end
end
