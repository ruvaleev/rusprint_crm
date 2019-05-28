require 'rails_helper'

RSpec.describe PrinterServiceGuidesController, type: :controller do
  describe 'POST #create' do
    context 'Authorized user' do
      sign_in_user

      it 'creates with valid attributes' do
        expect do
          post :create, params: { printer_service_guide: build(:printer_service_guide).attributes, format: :js }
        end.to change(PrinterServiceGuide, :count).by(1)
      end

      it "can't create with invalid attributes (without printer_service_guide_id)" do
        expect do
          post :create, params: { printer_service_guide: build(:printer_service_guide).attributes.except('model'), format: :js }
        end.to_not change(PrinterServiceGuide, :count)
      end
    end

    context 'Unauthorized user' do
      it "can't create Printer Service Guide" do
        expect do
          post :create, params: { printer_service_guide: build(:printer_service_guide).attributes, format: :js }
        end.to_not change(PrinterServiceGuide, :count)
      end
    end
  end
end
