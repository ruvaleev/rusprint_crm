# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should belong_to :manager }
  it { should have_many :orders }
  it { should have_many :employees }
  it { should have_many :printers }
  it { should have_many :archive_companies }

  it { should validate_presence_of :name }
  it { should validate_presence_of :adress }
  it { should validate_presence_of :telephone }
  it { is_expected.to callback(:increment_version).before(:save) }
  it { is_expected.to callback(:save_archive).after(:save) }
end
