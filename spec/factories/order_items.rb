FactoryBot.define do
  
  factory :order_item do
    order
    shopping_cart
    cartridge_item

    trait :cartridge_item do
      association(:item, factory: :cartridge_service_guide)
    end

  end

end