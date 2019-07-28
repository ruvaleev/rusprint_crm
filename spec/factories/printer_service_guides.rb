FactoryBot.define do
  factory :printer_service_guide_without_cartridges, class: 'PrinterServiceGuide' do
    sequence(:model) { |n| "Model number #{n}" }
    color { 'black' }
    fuser_life_count { 1600 }
    type_of_system { 'laser' }
    vendor { 'HP' }
  end

  factory :printer_service_guide, parent: :printer_service_guide_without_cartridges do
    after(:create) do |printer_service_guide|
      cartridge_service_guides = FactoryBot.create_list(:cartridge_service_guide_without_printers, 3)
      printer_service_guide.cartridges << cartridge_service_guides
    end
  end
end
