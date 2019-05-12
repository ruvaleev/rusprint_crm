require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  describe 'PUT #update' do
    let(:admin) { create(:user) }
    let(:order) { create(:order) }
    let(:shopping_cart) { create(:shopping_cart) }
    let(:order_item) { create(:order_item, owner: shopping_cart, order: order) }

    context 'Authorized user' do
      let(:master_role) { create(:role, name: 'master') }
      let(:master) { create(:user, role: master_role) }

      let(:own_order) { create(:order, master: master) }
      let(:own_shopping_cart) { create(:shopping_cart) }
      let(:own_order_item) { create(:order_item, owner: own_shopping_cart, order: own_order) }
      sign_in_user

      it 'updates price_cents' do
        put :update, params: { id: order_item, order_item: { price_cents: '1010.00 руб' }, format: :json }
        order_item.reload
        expect(order_item.price_cents).to eq 101000
      end

      it 'updates quantity' do
        put :update, params: { id: order_item, order_item: { quantity: '7' }, format: :json }
        order_item.reload
        expect(order_item.quantity).to eq 7
      end

      it "updates the order after updating order_item's price_cents" do
        put :update, params: { id: order_item, order_item: { price_cents: '1010.00 руб' }, format: :json }
        order.reload
        expect(order.revenue).to eq 1010
      end

      it "updates the order after updating order_item's quantity" do
        put :update, params: { id: order_item, order_item: { quantity: '7' }, format: :json }
        order.reload
        expect(order.qnt).to eq 7
      end

      it 'master update own order' do
        sign_in(master)
        put :update, params: { id: own_order_item, order_item: { price_cents: '1010.00 руб' }, format: :json }
        own_order_item.reload
        expect(own_order_item.price_cents).to eq 101000
      end

      it "master can't update not own order" do
        sign_in(master)
        put :update, params: { id: order_item, order_item: { price_cents: '1010.00 руб' }, format: :json }
        order_item.reload
        expect(order_item.price_cents).to_not eq 101000
      end

      it "order didn't update when master couldn't update not own order item" do
        sign_in(master)
        put :update, params: { id: order_item, order_item: { price_cents: '1010.00 руб' }, format: :json }
        order.reload
        expect(order.revenue).to_not eq 101000
      end
    end

    context 'Unauthorized user' do
      it "can't update orders" do
        put :update, params: { id: order_item, order_item: { price_cents: '1010.00 руб' }, format: :json }
        order_item.reload
        expect(order_item.price_cents).to_not eq 101000
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:admin) { create(:user) }
    let(:order) { create(:order) }
    let!(:order_item) { create(:order_item, owner: order.shopping_cart, order: order) }

    context 'Authorized user' do
      let(:master_role) { create(:role, name: 'master') }
      let(:master) { create(:user, role: master_role) }

      let(:manager_role) { create(:role, name: 'manager') }
      let(:manager) { create(:user, role: manager_role) }

      let(:own_order) { create(:order, master: master, manager: manager) }
      let!(:own_order_item) { create(:order_item, owner: own_order.shopping_cart, order: own_order) }

      context 'Master' do
        before { sign_in(master) }

        it "master deletes own order's order item" do
          expect { delete :destroy, params: { id: own_order_item, format: :json } }.to change(OrderItem, :count).by(-1)
        end

        it "master can't delete another order's order item" do
          expect { delete :destroy, params: { id: order_item, format: :json } }.to_not change(OrderItem, :count)
        end
      end

      context 'Admin' do
        before { sign_in(admin) }
        it "admin deletes order's order item" do
          expect { delete :destroy, params: { id: order_item, format: :json } }.to change(OrderItem, :count).by(-1)
        end
      end

      context 'Manager' do
        before { sign_in(manager) }
        it "manager deletes own order's order item" do
          expect { delete :destroy, params: { id: own_order_item, format: :json } }.to change(OrderItem, :count).by(-1)
        end

        it "manager deletes another order's order item" do
          expect { delete :destroy, params: { id: order_item, format: :json } }.to change(OrderItem, :count).by(-1)
        end
      end
    end

    context 'Unauthorized user' do
      it "can't delete order items" do
        expect { delete :destroy, params: { id: order_item, format: :json } }.to_not change(OrderItem, :count)
      end
    end
  end
end
