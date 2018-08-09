FactoryBot.define do
  
  factory :company do
  	name 'test company'
  	adress 'Red Rose Street, 1, 1'
  	telephone '89011010101'
  	sequence(:email) { |n| "user#{n}@test.com" }
  	association :manager, factory: :user
  end

  factory :invalid_company, class: 'Company' do
    name 'test company'
    adress 'Red Rose Street, 1, 1'
    telephone nil
    sequence(:email) { |n| "user#{n}@test.com" }
    association :manager, factory: :user
  end

  factory :customer, class: 'Company' do
    name 'test company'
    adress 'Red Rose Street, 1, 1'
    telephone '89011010101'
    sequence(:email) { |n| "user#{n}@test.com" }
    association :manager, factory: :user
  end

end
