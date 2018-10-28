require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to :customer }
  it { should belong_to :master }
  it { should belong_to :manager }

  # it { should have_many :log }

  it { should validate_presence_of :date_of_order }

end