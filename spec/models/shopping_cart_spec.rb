# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingCart do
  it { should have_one :order }

  describe 'cartridges' do
    let!(:shopping_cart) { create(:shopping_cart) }
    let!(:order_item) { create_list(:order_item, 4, owner: shopping_cart) }

    it 'returns array of items with only type "CartridgeServiceGuide"' do
      expect(shopping_cart.cartridge_order_items.pluck(:item_type).uniq).to eq ['CartridgeServiceGuide']
    end

    it 'returns all of cartridge order items for the order' do
      expect(shopping_cart.cartridge_order_items.count).to eq 4
    end
  end

  describe 'other order items' do
    let!(:shopping_cart) { create(:shopping_cart) }
    let!(:other_oi) { create_list(:other_oi, 4, owner: shopping_cart) }

    it 'returns array of items with only type "OtherOrderItem"' do
      expect(shopping_cart.other_order_items.pluck(:item_type).uniq).to eq ['OtherOrderItem']
    end

    it 'returns all of other order items for the order' do
      expect(shopping_cart.other_order_items.count).to eq 4
    end
  end
end
