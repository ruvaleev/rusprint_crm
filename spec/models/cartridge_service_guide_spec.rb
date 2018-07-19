require 'rails_helper'

RSpec.describe CartridgeServiceGuide, type: :model do
  it { should belong_to :printer_service_guide }

  it { should validate_presence_of :model }
  it { should validate_presence_of :color }
  it { should validate_presence_of :price_for_refill }
  it { should validate_presence_of :toner_life_count }

end
