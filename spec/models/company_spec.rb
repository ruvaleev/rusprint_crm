require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should belong_to :manager }
  it { should have_many :orders }
  it { should have_many :employees }
  it { should have_many :orders }
  it { should have_many :orders }

  it { should validate_presence_of :name }
  it { should validate_presence_of :adress }
  it { should validate_presence_of :telephone }
end