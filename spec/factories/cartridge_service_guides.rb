FactoryBot.define do
  factory :cartridge_service_guide do
    sequence(:model) { |n| "Model number #{n}" }
    color { 'black' }
    price { 1000 }
    toner_life_count { 1600 }
  end
end
