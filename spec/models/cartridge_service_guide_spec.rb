# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartridgeServiceGuide, type: :model do
  it { should belong_to :printer_service_guide }
  it { should have_many :order_items }

  it { should validate_presence_of :model }
  it { should validate_presence_of :color }
  it { should validate_presence_of :price }
  it { should validate_presence_of :toner_life_count }
  it do
    should validate_uniqueness_of(:model).scoped_to(:printer_service_guide_id)
                                         .with_message(I18n.t('cartridge_service_guides.errors.model_taken_psg'))
  end
end
