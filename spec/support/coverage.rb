require 'simplecov'
SimpleCov.coverage_dir('tmp/coverage')

SimpleCov.start do
  add_filter 'spec'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Services', 'app/services'
  add_group 'Serializers', 'app/serializers'
  add_group 'Jobs', 'app/jobs'
end
