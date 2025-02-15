FactoryBot.define do
  factory :import do
    file { fixture_file_upload('companies.csv') }
  end
end
