FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Example Co##{n}" }
    sequence(:registration_number) { |n| 123456789 + n }

    transient do
      addresses_count { 1 }
    end

    after(:build) do |company, evaluator|
      if company.addresses.empty?
        company.addresses = build_list(:address, evaluator.addresses_count, company: company)
      end
    end
  end
end
