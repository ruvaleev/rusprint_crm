# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingCart do
  describe 'order id' do
    let(:shopping_cart) { create(:shopping_cart) }
    let(:order) { create(:order) }
    let(:order_item) { create(:order_item, order: order, owner: shopping_cart) }
    let(:other_oi) { create(:other_oi, order: order, owner: shopping_cart) }
    it "returns order's id with that shopping cart with order item" do
      order_item
      expect(shopping_cart.order_id).to eq order_item.order_id
    end

    it "returns order's id with that shopping cart with other order item" do
      other_oi
      expect(shopping_cart.order_id).to eq other_oi.order_id
    end

    it 'returns nil with shopping cart without order item' do
      expect(shopping_cart.order_id).to eq nil
    end
  end
end
