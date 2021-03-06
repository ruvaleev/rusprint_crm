FactoryBot.define do
  factory :order do
    after(:build) do |order|
      order.shopping_cart ||= FactoryBot.create(:shopping_cart, order: order)
    end

    date_of_order { 2.days.ago }
    date_of_complete { 1.day.ago }
    suitable_time_start '10:00'
    suitable_time_end '12:00'
    additional_data 'some additional information'
    printers 'some models of printers'
    cartridges 'some cartridges'
    qnt 5
    association :customer, factory: :company
    association :manager, factory: :user
    association :master, factory: :user
    revenue 2000
    expense 400
    paid true
  end

  factory :invalid_order, class: 'Order' do
    after(:build) do |order|
      order.shopping_cart ||= FactoryBot.create(:shopping_cart, order: order)
    end

    date_of_complete { 1.day.ago }
    suitable_time_start '06:00'
    suitable_time_end '08:00'
    additional_data 'some additional information'
    printers 'some models of printers'
    cartridges 'some cartridges'
    qnt 4
    association :customer, factory: :company
    association :manager, factory: :user
    association :master, factory: :user
    revenue 2000
    expense 400
    paid false
  end
end
