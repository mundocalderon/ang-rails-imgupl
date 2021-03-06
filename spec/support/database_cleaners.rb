require 'database_cleaner'

DatabaseCleaner.allow_production = true
DatabaseCleaner.allow_remote_database_url = true

shared_context "db_cleanup" do |ar_strategy=:truncation|
  before(:all) do
  	DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:active_record].strategy = ar_strategy
    DatabaseCleaner.clean_with(:truncation)
  end
  after(:each, :type=>feature) do
    Capybara.reset_sessions!
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end

shared_context "db_scope" do 
  before(:each) do
    DatabaseCleaner.start
  end
  after(:each) do
    DatabaseCleaner.clean
  end
end

shared_context "db_clean_after" do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end

shared_context "db_cleanup_each" do |ar_strategy=:truncation|
  before(:all) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:active_record].strategy = ar_strategy
    DatabaseCleaner.clean_with(:truncation)
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
  before(:each) do
    DatabaseCleaner.start
  end
  after(:each) do
    Capybara.reset_sessions! if self.class.metadata[:js]
    DatabaseCleaner.clean
  end
end