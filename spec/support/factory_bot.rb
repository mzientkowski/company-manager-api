FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Rails::FileFixtureSupport
  include RSpec::Rails::FixtureFileUploadSupport
end
