require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  describe 'POST #create' do
    context 'Authorized user' do
      sign_in_user
      it 'creates with valid attributes' do
        expect do
          post :create, params: { company: attributes_for(:company), format: :js }
        end.to change(Company, :count).by(1)
      end

      it "can't create with invalid attributes" do
        expect do
          post :create, params: { company: attributes_for(:invalid_company), format: :js }
        end.to_not change(Company, :count)
      end
    end

    context 'Unauthorized user' do
      it "can't create Company" do
        expect do
          post :create, params: { company: attributes_for(:company), format: :js }
        end.to_not change(Company, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:company) { create(:company) }
    context 'Authorized user' do
      sign_in_user
      it 'update with valid attributes' do
        put :update, params: { id: company, company: { name: 'new name' } }
        company.reload
        expect(company.name).to eq 'new name'
      end

      it "can't update with invalid attributes" do
        put :update, params: { id: company, company: { name: '' } }
        company.reload
        expect(company.name).to_not eq ''
      end
    end

    context 'Unauthorized user' do
      it "can't update Company" do
        put :update, params: { id: company, company: { name: 'new name' } }
        company.reload
        expect(company.name).to_not eq 'new name'
      end
    end
  end

  describe 'GET #get_printers' do
    sign_in_user
    let(:customer) { create(:company) }
    let(:order) { create(:order, customer: customer) }
    before { get :get_printers, params: { id: customer }, xhr: true }

    it "returns customer's @printers" do
      expect(assigns(:printers)).to eq customer.printers
    end
    xit 'returns printers @vendors' do
      # Не актуальный кейс пока (отменили константу временно)
      expect(assigns(:vendors)).to eq Printer::VENDORS.map.with_index.to_a
    end
  end
end
