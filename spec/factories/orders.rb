FactoryBot.define do
  
  factory :order do
    date_of_order { 2.days.ago }
    date_of_complete { 1.days.ago }
    suitable_time_start "10:10"
    suitable_time_end "12:10"
    additional_data 'some additional information'
    printers 'some models of printers'
    cartridges 'some cartridges'
    qnt 5
    association :customer, factory: :company
    association :manager, factory: :user
    association :master, factory: :user
    revenue 2000
    expense 400
    profit 1600
    status "closed"
    paid true
  end

  factory :invalid_order, class: 'Order' do
    date_of_complete { 1.days.ago }
    suitable_time_start "06:10"
    suitable_time_end "08:10"
    additional_data 'some additional information'
    printers 'some models of printers'
    cartridges 'some cartridges'
    qnt 4
    association :customer, factory: :company
    association :manager, factory: :user
    association :master, factory: :user
    revenue 2000
    expense 400
    profit 1600
    status "closed"
    paid false
  end

end