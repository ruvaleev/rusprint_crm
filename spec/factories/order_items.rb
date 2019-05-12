FactoryBot.define do
  factory :order_item do
    order
    association(:owner, factory: :shopping_cart)
    cartridge_item
    quantity { 1 }

    trait :cartridge_item do
      association(:item, factory: :cartridge_service_guide)
    end
  end

  factory :other_oi, class: 'OrderItem' do
    order
    association(:owner, factory: :shopping_cart)
    cartridge_item
    quantity { 1 }

    trait :cartridge_item do
      association(:item, factory: :other_order_item)
    end
  end
end
