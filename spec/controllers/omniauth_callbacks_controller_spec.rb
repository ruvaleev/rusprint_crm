require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

  let(:user) { create(:user) }
  let(:twitter_authorization) { create(:authorization, user: user, provider: 'twitter', uid: '123545') }
  let(:facebook_authorization) { create(:authorization, user: user, provider: 'facebook', uid: '123545') }

  OmniAuth.config.test_mode = true

  describe "GET|POST #twitter" do

    before do
      request.env["devise.mapping"] = Devise.mappings[:user] 
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        :provider => 'twitter',
        :uid => '123545',
        :info => { some_parameter: true }
      })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
   end

    it "creates new user if he doesn't exist" do
      expect{ post :twitter }.to change(User, :count).by(1)
    end

    it 'redirects to a set_email page if user has only temporary email' do
      expect(post :twitter).to redirect_to set_email_user_path(User.last)
    end

    it "doesn't create new user if he is already exists" do
      twitter_authorization
      expect{ post :twitter }.to_not change(User, :count)
    end

    it 'redirects to a root page, if user is already has real email' do
      twitter_authorization
      expect(post :twitter).to redirect_to root_path
    end

    it 'creates new authorization' do
      expect{ post :twitter }.to change(Authorization, :count).by(1)
    end

    it "doesn't create the same authorization" do
      twitter_authorization
      expect{ post :twitter }.to_not change(Authorization, :count)
    end

  end

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

    it 'redirects to a root page, if user is already has real email' do
      expect(post :facebook).to redirect_to root_path
    end

    it 'redirects to a set_email page if user has only temporary email' do
      request.env["devise.mapping"] = Devise.mappings[:user] 
      OmniAuth.config.mock_auth[:facebook_without_email] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '123546',
        :info => { some_data: :true }
      })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook_without_email]
      
      expect(post :facebook).to redirect_to set_email_user_path(User.last)
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