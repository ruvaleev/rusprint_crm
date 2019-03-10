require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET #index' do
    let(:manager_role) { create(:role, name: 'manager') }
    let(:user) { create(:user, role: manager_role) }
    let(:orders) { create_list(:order, 3) }

    context 'Authorized user' do
      before do
        sign_in(user)
        get :index
      end

      it 'populates an array of all orders' do
        expect(assigns(:orders)).to match_array(orders)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Unauthorized user' do
      it 'redirects to signup page' do
        redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    let(:manager_role) { create(:role, name: 'manager') }
    let(:user) { create(:user, role: manager_role) }
    let(:company) { create(:company) }
    let(:cartridge_service_guide) { build(:cartridge_service_guide) }
    let(:shopping_cart) { create(:shopping_cart) }

    context 'Authorized user' do
      sign_in_user
      it 'creates with valid attributes' do
        session[:shopping_cart_id] = shopping_cart.id
        expect do
          post :create, params: { order: build(:order).attributes, customer: company, format: :js }
        end.to change(Order, :count).by(1)
      end
      it "can't create with invalid attributes" do
        session[:shopping_cart_id] = shopping_cart.id
        expect do
          post :create, params: { order: build(:invalid_order).attributes, customer: company, format: :js }
        end.to_not change(Order, :count)
      end
    end

    context 'Unauthorized user' do
      it "can't create an Order" do
        expect do
          post :create, params: { order: build(:order).attributes, customer: company, format: :js }
        end.to_not change(Order, :count)
      end
    end
  end
end
