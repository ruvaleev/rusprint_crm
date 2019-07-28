# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrintersCompatibility, type: :model do
  it { should belong_to(:printer_service_guide) }
  it { should belong_to(:compatible) }
  it { should validate_uniqueness_of(:printer_service_guide_id).scoped_to(:compatible_id, :compatible_type) }
end
