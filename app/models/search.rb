class Search
  include ActiveModel::Model

  SCOPES = %w(answers questions users comments).freeze

  attr_accessor :query, :scope
  attr_reader :result

  validates :query, presence: true

  def run
    if valid?
      klass_name = SCOPES.include?(scope) ? scope.classify.constantize : ThinkingSphinx
      @result = klass_name.search(ThinkingSphinx::Query.escape(query))
    end
  end
end
