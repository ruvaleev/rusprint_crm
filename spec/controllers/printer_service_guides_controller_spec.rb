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
          post :create, params: {
            printer_service_guide: build(:printer_service_guide).attributes.except('model'), format: :js
          }
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

  describe 'GET #search_models' do
    sign_in_user
    let(:printer_service_guide) { create(:printer_service_guide, model: 'HP test printer') }
    let(:printer) { create(:printer) }
    let(:search) { PrinterModelSearch.new(model_like: 'HP') }

    it "returns user's search results as @models" do
      get :search_models, params: { printer_model_search: { model_like: 'HP' } }, xhr: true
      expect(assigns(:models)).to eq search.results
    end
  end
end
