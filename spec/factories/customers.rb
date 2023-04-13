FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    created_at { Faker::Time.between(from: 2.years.ago, to: Time.now) }
    updated_at { created_at }
  end

  trait :with_successful_transactions do
    transient do
      transactions_count { 1 }
      transactions_traits { [:successful] }
    end

    after(:create) do |customer, evaluator|
      create_list(:transaction, 
        evaluator.transactions_count, 
        *evaluator.transactions_traits, 
        invoice: create(:invoice, customer: customer))
    end
  end
end