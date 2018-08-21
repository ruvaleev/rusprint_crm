require 'rails_helper'

RSpec.describe PrinterServiceGuide, type: :model do
  it { should have_many :cartridge_service_guide }

  it { should validate_presence_of :model }
  it { should validate_presence_of :type_of_system }
end
