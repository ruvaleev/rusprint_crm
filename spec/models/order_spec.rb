# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to :customer }
  it { should belong_to :master }
  it { should belong_to :manager }

  it { should have_many :logs }
  it { should have_many :order_items }

  it { should have_one :shopping_cart }

  it { should validate_presence_of :date_of_order }
  it { should validate_presence_of :shopping_cart_id }

  it { is_expected.to callback(:calculate_profit).before(:save) }
  describe 'state machine' do
    let(:order) { create(:order) }
    let(:unpaid_order) { create(:order, paid: false) }
    context "order has 'pending' status as default" do
      it { expect(order).to have_state(:pending) }
    end

    context "order can be transferred to 'signed' status from 'pending'" do
      it { expect(order).to transition_from(:pending).to(:signed).on_event(:sign) }
    end

    context "order can be transferred to 'completed' status from 'signed'" do
      it { expect(order).to transition_from(:signed).to(:completed).on_event(:complete) }
    end

    context "order can be transferred to 'closed' status from 'completed'" do
      it { expect(order).to transition_from(:completed).to(:closed).on_event(:close) }
    end

    context "order can be transferred to 'closed' status from 'canceled'" do
      it { expect(order).to transition_from(:canceled).to(:closed).on_event(:close) }
    end

    context "order can be transferred to 'canceled' status from 'pending'" do
      it { expect(order).to transition_from(:pending).to(:canceled).on_event(:cancel) }
    end

    context "order can be transferred to 'canceled' status from 'signed'" do
      it { expect(order).to transition_from(:signed).to(:canceled).on_event(:cancel) }
    end

    context "order can be transferred to 'canceled' status from 'completed'" do
      it { expect(order).to transition_from(:completed).to(:canceled).on_event(:cancel) }
    end

    context "order can be transferred to 'canceled' status from 'closed'" do
      it { expect(order).to transition_from(:closed).to(:canceled).on_event(:cancel) }
    end

    context 'when order is not paid' do
      it 'it cannot be closed' do
        unpaid_order.status = 'completed'
        expect(unpaid_order).to_not allow_transition_to(:closed)
      end
    end

    context 'when trying to delete order' do
      it 'is not destroyed really' do
        order.destroy
        expect(Order.deleted.last.id).to eq order.id
      end
    end
  end

  describe 'cartridges' do
    let!(:order) { create(:order) }
    let!(:order_item) { create_list(:order_item, 4, order: order) }

    it 'returns array of items with only type "CartridgeServiceGuide"' do
      expect(order.cartridge_order_items.pluck(:item_type).uniq).to eq ['CartridgeServiceGuide']
    end

    it 'returns all of cartridge order items for the order' do
      expect(order.cartridge_order_items.count).to eq 4
    end
  end

  describe 'other order items' do
    let!(:order) { create(:order) }
    let!(:other_oi) { create_list(:other_oi, 4, order: order) }

    it 'returns array of items with only type "OtherOrderItem"' do
      expect(order.other_order_items.pluck(:item_type).uniq).to eq ['OtherOrderItem']
    end

    it 'returns all of other order items for the order' do
      expect(order.other_order_items.count).to eq 4
    end
  end
end
