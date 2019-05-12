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
      before { session[:shopping_cart_id] = shopping_cart.id }

      context 'with existed customer' do
        it 'creates with valid attributes' do
          expect do
            post :create, params: { order: attributes_for(:order).merge(customer_id: company), format: :js }
          end.to change(Order, :count).by(1)
        end

        it "can't create with invalid attributes" do
          expect do
            post :create, params: { order: attributes_for(:invalid_order).merge(customer_id: company), format: :js }
          end.to_not change(Order, :count)
        end

        it "updates shopping_cart's order_id after creating" do
          post :create, params: { order: attributes_for(:order)
            .merge(customer_id: company), customer: company, format: :js }
          expect(shopping_cart.reload.order_id).to eq Order.last.id
        end

        it "can't create without shopping_cart_id" do
          session.delete(:shopping_cart_id)
          expect do
            post :create, params: { order: attributes_for(:order).merge(customer_id: company), format: :js }
          end.to_not change(Order, :count)
        end
      end

      context 'with new customer' do
        it 'creates with valid attributes' do
          expect do
            post :create, params: { order: attributes_for(:order),
                                    company: company.attributes, new_client_flag: true, format: :js }
          end.to change(Order, :count).by(1)
        end

        it "can't create with invalid attributes" do
          expect do
            post :create, params: { order: attributes_for(:invalid_order),
                                    company: company.attributes, new_client_flag: true, format: :js }
          end.to_not change(Order, :count)
        end

        it "updates shopping_cart's order_id after creating" do
          post :create, params: { order: attributes_for(:order),
                                  company: company.attributes, new_client_flag: true, format: :js }
          expect(shopping_cart.reload.order_id).to eq Order.last.id
        end

        it "can't create without shopping_cart_id" do
          session.delete(:shopping_cart_id)
          expect do
            post :create, params: { order: attributes_for(:order),
                                    company: company.attributes, new_client_flag: true, format: :js }
          end.to_not change(Order, :count)
        end
      end
    end

    context 'Unauthorized user' do
      it "can't create an Order" do
        expect do
          post :create, params: { order: attributes_for(:order).merge(customer_id: company), format: :js }
        end.to_not change(Order, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:admin) { create(:user) }
    let(:company) { create(:company) }
    let(:order) { create(:order) }
    let(:cartridge_service_guide) { build(:cartridge_service_guide) }
    let(:shopping_cart) { create(:shopping_cart) }

    context 'Authorized user' do
      let(:master_role) { create(:role, name: 'master') }
      let(:master) { create(:user, role: master_role) }
      let(:own_order) { create(:order, master: master) }
      sign_in_user

      it 'updates with valid attributes' do
        put :update, params: { id: order, order: { additional_data: 'new additional_data' } }
        order.reload
        expect(order.additional_data).to eq 'new additional_data'
      end

      it "can't update with invalid attributes" do
        put :update, params: { id: order, order: { date_of_order: '' } }
        order.reload
        expect(order.date_of_order).to_not eq ''
      end

      it 'master update own order' do
        sign_in(master)
        put :update, params: { id: own_order, order: { additional_data: 'new additional_data' } }
        own_order.reload
        expect(own_order.additional_data).to eq 'new additional_data'
      end
      it "master can't update not own order" do
        sign_in(master)
        put :update, params: { id: order, order: { additional_data: 'new additional_data' } }
        order.reload
        expect(order.additional_data).to_not eq 'new additional_data'
      end
    end

    context 'Unauthorized user' do
      it "can't update orders" do
        put :update, params: { id: order, order: { additional_data: 'new additional_data' } }
        order.reload
        expect(order.additional_data).to_not eq 'new additional_data'
      end
    end
  end

  describe 'GET #show' do
    sign_in_user
    let(:order) { create(:order) }
    before { get :show, params: { id: order }, xhr: true, format: :js }

    it 'assigns the requested order to @order' do
      expect(assigns(:order)).to eq order
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end
