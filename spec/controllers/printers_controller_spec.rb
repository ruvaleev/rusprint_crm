require 'rails_helper'

RSpec.describe PrintersController, type: :controller do
  describe 'POST #create' do
    context 'Authorized user' do
      sign_in_user
      let(:company) { create(:company) }
      let(:printer_service_guide) { create(:printer_service_guide) }
      it 'creates with valid attributes' do
        expect do
          post :create, params: { printer: build(:printer).attributes, format: :js }
        end.to change(Printer, :count).by(1)
      end

      it "can't create with invalid attributes (without printer_service_guide_id)" do
        expect do
          post :create, params: { printer: { company_id: company.id }, format: :js }
        end.to_not change(Printer, :count)
      end
    end

    context 'Unauthorized user' do
      let(:company) { create(:company) }
      let(:printer_service_guide) { create(:printer_service_guide) }
      it "can't create an Order" do
        expect do
          post :create, params: { printer: build(:printer).attributes, format: :js }
        end.to_not change(Printer, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:printer_service_guide) { create(:printer_service_guide) }
    let(:printer) { create(:printer) }

    context 'Authorized user' do
      let(:master_role) { create(:role, name: 'master') }
      let(:master) { create(:user, role: master_role) }
      sign_in_user

      it 'updates with valid attributes' do
        put :update, params: { id: printer, printer: { additional_data: 'new additional_data' } }
        printer.reload
        expect(printer.additional_data).to eq 'new additional_data'
      end

      it "can't update with invalid attributes" do
        put :update, params: { id: printer, printer: { printer_service_guide_id: '' } }
        printer.reload
        expect(printer.printer_service_guide_id).to_not eq ''
      end
    end

    context 'Unauthorized user' do
      it "can't update orders" do
        put :update, params: { id: printer, order: { additional_data: 'new additional_data' } }
        printer.reload
        expect(printer.additional_data).to_not eq 'new additional_data'
      end
    end
  end
end
