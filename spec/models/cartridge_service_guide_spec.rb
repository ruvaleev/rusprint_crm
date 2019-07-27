# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartridgeServiceGuide, type: :model do
  it { should have_and_belong_to_many :printer_service_guides }
  it { should have_many :order_items }

  it { should validate_presence_of :model }
  it { should validate_presence_of :color }
  it { should validate_presence_of :price }
  it { should validate_presence_of :toner_life_count }
  it do
    should validate_uniqueness_of(:model).with_message(I18n.t('cartridge_service_guides.errors.model_taken_psg'))
  end

  describe '#printers' do
    let(:cartridge_service_guide) { create(:cartridge_service_guide) }
    it 'returns cartridge collection' do
      expect(cartridge_service_guide.printers).to eq cartridge_service_guide.printer_service_guides
    end
  end
end
