FactoryBot.define do
  factory :address do
    sequence(:street) { |n| "Example St##{n}" }
    sequence(:city) { |n| "Example City##{n}" }
    postal_code { rand(10000..99999).to_s }
    country { 'USA' }

    company
  end
end
