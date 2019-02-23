FactoryBot.define do
  
  factory :user do
  	name 'Test name'
    association :role, factory: :admin_role
  	sequence(:email) { |n| "user#{n}@test.com" }
  	telephone '89022010102'
  	password '1234567'
  	password_confirmation '1234567'
  end

end
