# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrinterServiceGuide, type: :model do
  it { should have_many(:cartridges).through(:printers_compatibilities) }
  it { should validate_presence_of :model }
  it { should validate_presence_of :type_of_system }
  it { should validate_uniqueness_of(:model).scoped_to(:vendor) }
end
