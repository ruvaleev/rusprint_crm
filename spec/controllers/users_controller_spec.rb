require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { create(:user) }

  describe "GET #set_email" do
    it 'renders the set email template' do
      sign_in(user)
      expect(get :set_email, params: { id: user }).to render_template :set_email
    end
  end

  describe "PATCH #update" do
    before do
      sign_in(user)
      patch :update, params: { id: user, user: { email: 'new_email@example.com' } }
      user.reload
    end

    it "updates user's email" do
      expect(user.email).to eq 'new_email@example.com'
    end

    it 'redirects to index page' do
      expect(response).to redirect_to root_path
    end
  end
end