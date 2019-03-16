FactoryBot.define do
  factory :printer do
    association :company
    association :printer_service_guide
    serial_number FFaker::Vehicle.vin
  end

  factory :invalid_printer, class: 'Printer' do
    association :company
    serial_number FFaker::Vehicle.vin
  end
end
