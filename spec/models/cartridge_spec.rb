require 'rails_helper'

RSpec.describe Cartridge, type: :model do
  it { should belong_to :cartridge_service_guide }
  it { should have_many :log }

end