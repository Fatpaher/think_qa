ActionDispatch::IntegrationTest
  Capybara.server_port = 3001
  Capybara.app_host = 'http://localhost:3001'

RSpec.configure do |config|
  config.after(:all) do
    config.before(:each) { ActionMailer::Base.deliveries.clear }
  end
end
