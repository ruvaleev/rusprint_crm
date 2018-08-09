FactoryBot.define do
  
  factory :order do
    date_of_order { 2.days.ago }
    date_of_complete { 1.days.ago }
    suitable_time "#{ 1.days.ago } 10:10".to_time
    additional_data 'some additional information'
    printers 'some models of printers'
    cartridges 'some cartridges'
    association :customer, factory: :company
    revenue 2000
  end

  factory :invalid_order, class: 'Order' do
    date_of_complete { 1.days.ago }
    suitable_time "#{ 1.days.ago } 10:10".to_time
    additional_data 'some additional information'
    printers 'some models of printers'
    cartridges 'some cartridges'
    association :customer, factory: :company
    revenue 2000
  end

end