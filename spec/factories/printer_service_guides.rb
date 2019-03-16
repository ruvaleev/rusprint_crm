FactoryBot.define do
  factory :printer_service_guide do
    sequence(:model) { |n| "Model number #{n}" }
    color { 'black' }
    fuser_life_count { 1600 }
    type_of_system { 'laser' }
    vendor { 'HP' }
  end
end
