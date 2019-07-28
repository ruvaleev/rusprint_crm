FactoryBot.define do
  factory :cartridge_service_guide_without_printers, class: 'CartridgeServiceGuide' do
    sequence(:model) { |n| "Model number #{n}" }
    color { 'black' }
    price { 1000 }
    toner_life_count { 1600 }
  end

  factory :cartridge_service_guide, parent: :cartridge_service_guide_without_printers do
    after(:create) do |cartridge_service_guide|
      printer_service_guides = FactoryBot.create_list(:printer_service_guide_without_cartridges, 3)
      cartridge_service_guide.printer_service_guides << printer_service_guides
    end
  end
end
