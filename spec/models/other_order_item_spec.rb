require 'rails_helper'

RSpec.describe OtherOrderItem, type: :model do
  it { should have_many :order_items }
  it { should validate_presence_of :body }
end