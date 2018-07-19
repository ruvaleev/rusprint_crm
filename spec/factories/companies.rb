FactoryBot.define do
  
  factory :company do
  	name 'test company'
  	adress 'Red Rose Street, 1, 1'
  	telephone '89011010101'
  	sequence(:email) { |n| "user#{n}@test.com" }
  	user
  end

end
