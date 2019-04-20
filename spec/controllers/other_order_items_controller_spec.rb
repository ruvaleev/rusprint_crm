require 'rails_helper'

RSpec.describe OtherOrderItemsController, type: :controller do
  describe 'PUT #update' do
    let(:admin) { create(:user) }
    let(:order) { create(:order) }
    let(:shopping_cart) { create(:shopping_cart) }
    let(:other_order_item) { create(:other_order_item) }
    let(:other_oi) { create(:other_oi, item: other_order_item, owner: shopping_cart, order: order) }

    context 'Authorized user' do
      let(:master_role) { create(:role, name: 'master') }
      let(:master) { create(:user, role: master_role) }

      let(:own_order) { create(:order, master: master) }
      let(:own_shopping_cart) { create(:shopping_cart) }
      let(:own_other_order_item) { create(:other_order_item) }
      let(:own_other_oi) { create(:other_oi, item: own_other_order_item, owner: own_shopping_cart, order: own_order) }
      sign_in_user

      it "updates other_order_item's body" do
        put :update, params: { id: other_order_item, other_order_item: { body: 'Другая услуга' }, format: :json }
        other_order_item.reload
        expect(other_order_item.body).to eq 'Другая услуга'
      end

      it 'master update own order' do
        own_other_oi
        sign_in(master)
        put :update, params: { id: own_other_order_item, other_order_item: { body: 'Другая услуга' }, format: :json }
        own_other_order_item.reload
        expect(own_other_order_item.body).to eq 'Другая услуга'
      end

      it "master can't update not own order" do
        other_oi
        sign_in(master)
        put :update, params: { id: other_order_item, other_order_item: { body: 'Другая услуга' }, format: :json }
        other_order_item.reload
        expect(other_order_item.body).to_not eq 'Другая услуга'
      end
    end

    context 'Unauthorized user' do
      it "can't update orders" do
        put :update, params: { id: other_order_item, other_order_item: { body: 'Другая услуга' }, format: :json }
        other_order_item.reload
        expect(other_order_item.body).to_not eq 'Другая услуга'
      end
    end
  end
end
