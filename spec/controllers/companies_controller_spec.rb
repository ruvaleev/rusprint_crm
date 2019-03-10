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
end
