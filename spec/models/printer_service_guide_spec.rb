# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrinterServiceGuide, type: :model do
  it { should have_and_belong_to_many :cartridge_service_guides }

  it { should validate_presence_of :model }
  it { should validate_presence_of :type_of_system }

  describe '#cartridges' do
    let(:printer_service_guide) { create(:printer_service_guide) }
    it 'returns cartridge collection' do
      expect(printer_service_guide.cartridges).to eq printer_service_guide.cartridge_service_guides
    end
  end
end
