require 'rails_helper'

RSpec.describe PricesController, type: :controller do
  describe 'POST #create' do
    let(:manager_role) { create(:role, name: 'manager') }
    let(:manager) { create(:user, role: manager_role) }
    let!(:price_csv_file) { fixture_file_upload('files/price.csv', 'text/csv') }

    context 'Authorized user' do
      before do
        sign_in(manager)
      end

      it 'creates Price' do
        expect { post :create, params: { price: { file: price_csv_file } } }.to change(Price, :count)
      end

      it 'redirects to root path' do
        expect(post(:create, params: { price: { file: price_csv_file } })).to redirect_to root_path
      end
    end
  end
end
