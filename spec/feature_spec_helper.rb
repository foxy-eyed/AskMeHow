require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include AcceptanceHelper,  type: :feature
  config.include WaitForAjax,       type: :feature
  config.include OmniauthMacros,    type: :feature
  config.include SphinxHelpers,     type: :feature

  Capybara.javascript_driver = :webkit
  Capybara.server = :puma

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
    index
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
