require 'rails_helper'

RSpec.describe ShoppingCartsController, type: :controller do
  let!(:shopping_cart) { ShoppingCart.create }
  let!(:cartridge) { create(:cartridge_service_guide) }

  describe 'POST #create' do
    context "shopping cart doesn't exist" do
      it "creates new shopping cart" do
        expect { post :create, params: { item_type: cartridge.class.name, quantity: 1, product_id: cartridge.id }, format: :js }.to change(ShoppingCart, :count).by(1)
      end
    end

    context "shopping cart exists" do
      before { session[:shopping_cart_id] = shopping_cart.id }
      it "finds existing shopping cart" do
        expect { post :create, params: { item_type: cartridge.class.name, quantity: 1, product_id: cartridge.id }, format: :js }.to_not change(ShoppingCart, :count)
      end

      it 'creates shopping items in the cart' do
        expect { post :create, params: { item_type: cartridge.class.name, quantity: 1, product_id: cartridge.id }, format: :js }.to change(shopping_cart.shopping_cart_items, :count).by(1)
      end
    end
  end

  describe 'POST #clear' do
    it 'clears the shopping cart' do
      session[:shopping_cart_id] = shopping_cart.id
      shopping_cart.add(cartridge, cartridge.price, 1)
      post :clear, params: { id: shopping_cart.id }, format: :js
      shopping_cart.reload
      expect(shopping_cart.total_unique_items).to eq 0
    end
  end

  describe 'DELETE #destroy' do
    it 'removes products from the shopping cart' do
      session[:shopping_cart_id] = shopping_cart.id
      shopping_cart.add(cartridge, cartridge.price, 2)
      delete :destroy, params: { id: shopping_cart.id, item_type: cartridge.class.name, quantity: 1, product_id: cartridge.id }, format: :js
      expect(shopping_cart.total_unique_items).to eq 1
    end
  end
end
