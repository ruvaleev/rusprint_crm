require 'rails_helper'

RSpec.describe Printer, type: :model do
  it { should belong_to :printer_service_guide }
  # it { should have_many :log }

  it { should validate_presence_of :printer_service_guide_id }
end