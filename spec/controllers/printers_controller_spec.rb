require 'rails_helper'

RSpec.describe PrintersController, type: :controller do
  describe 'POST #create' do
    context 'Authorized user' do
      sign_in_user
      let(:company) { create(:company) }
      let(:printer_service_guide) { create(:printer_service_guide) }
      it 'creates with valid attributes' do
        expect do
          post :create, params: { printer: build(:printer).attributes, company_id: company.id, printer_service_guide_id: printer_service_guide.id, format: :js }
        end.to change(Printer, :count).by(1)
      end

      it "can't create with invalid attributes (without printer_service_guide_id)" do
        expect do
          post :create, params: { printer: build(:printer).attributes, company_id: company.id, format: :js }
        end.to_not change(Printer, :count)
      end
    end

    context 'Unauthorized user' do
      let(:company) { create(:company) }
      let(:printer_service_guide) { create(:printer_service_guide) }
      it "can't create an Order" do
        expect do
          post :create, params: { printer: build(:printer).attributes, company_id: company.id, printer_service_guide_id: printer_service_guide.id, format: :js }
        end.to_not change(Printer, :count)
      end
    end
  end

  describe 'GET #get_models' do
    sign_in_user
    let(:printer_service_guide) { create(:printer_service_guide, model: "HP test printer") }
    let(:printer) { create(:printer) }
    let(:search) { PrinterModelSearch.new(model_like: 'HP') }

    it "returns user's search results as @models" do
      get :get_models, params: { printer_model_search: { model_like: 'HP' } }, xhr: true
      expect(assigns(:models)).to eq search.results
    end
  end
end
