# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OtherOrderItem, type: :model do
  it { should have_one :order_item }
  it { should validate_presence_of :body }
  it { should validate_presence_of :price }
end
