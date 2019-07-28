# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartridgeServiceGuide, type: :model do
  it { should have_many(:printer_service_guides).through(:printers_compatibilities) }
  it { should have_many :order_items }

  it { should validate_presence_of :model }
  it { should validate_presence_of :color }
  it { should validate_presence_of :price }
  it { should validate_presence_of :toner_life_count }

  describe '#printers' do
    let(:cartridge_service_guide) { create(:cartridge_service_guide) }
    it 'returns cartridge collection' do
      expect(cartridge_service_guide.printers).to eq cartridge_service_guide.printer_service_guides
    end
  end
end
