# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it { should belong_to :order }
  it { should belong_to :item }

  describe 'without_cents' do
    let(:order_item) { create(:order_item, price_cents: 400000) }

    it 'returns price_cents without cents (divided by 100)' do
      expect(order_item.without_cents).to eq order_item.price_cents / 100
    end
  end
end
