FactoryBot.define do
  factory :comment do
    user
    body "Test comment's body"
    association :commentable, factory: :answer  
  end
end
