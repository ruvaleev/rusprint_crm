require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let!(:customer_role) { create(:role, name: 'customer') }
  let(:admin_role) { create(:role, name: 'admin') }
  let(:user) { create(:user, role: admin_role) }
  let(:facebook_authorization) { create(:authorization, user: user, provider: 'facebook', uid: '123545') }

  OmniAuth.config.test_mode = true


  describe "GET|POST #facebook" do

    before do
      request.env["devise.mapping"] = Devise.mappings[:user] 
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '123545',
        :info => { email: 'facebook_mail@mail.ru' }
      })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
   end

    it "creates new user if he doesn't exist" do
      expect{ post :facebook }.to change(User, :count).by(1)
    end

    it 'redirects to a root page' do
      expect(post :facebook).to redirect_to root_path
    end

    it 'creates new authorization' do
      expect{ post :facebook }.to change(Authorization, :count).by(1)
    end

    it "doesn't create the same authorization" do
      facebook_authorization
      expect{ post :facebook }.to_not change(Authorization, :count)
    end
  end
end