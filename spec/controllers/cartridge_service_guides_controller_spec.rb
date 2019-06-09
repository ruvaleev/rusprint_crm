require 'rails_helper'

RSpec.describe CartridgeServiceGuidesController, type: :controller do
  describe 'POST #create' do
    context 'Authorized user' do
      sign_in_user

      it 'creates with valid attributes' do
        expect do
          post :create, params: { cartridge_service_guide: build(:cartridge_service_guide).attributes, format: :js }
        end.to change(CartridgeServiceGuide, :count).by(1)
      end

      it "can't create with invalid attributes (without cartridge_service_guide_id)" do
        expect do
          post :create, params: {
            cartridge_service_guide: build(:cartridge_service_guide).attributes.except('model'), format: :js
          }
        end.to_not change(CartridgeServiceGuide, :count)
      end
    end

    context 'Unauthorized user' do
      it "can't create Cartridge Service Guide" do
        expect do
          post :create, params: { cartridge_service_guide: build(:cartridge_service_guide).attributes, format: :js }
        end.to_not change(CartridgeServiceGuide, :count)
      end
    end
  end
end
