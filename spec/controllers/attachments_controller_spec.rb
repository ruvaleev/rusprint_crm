require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:my_question) { create(:question, user: user) }
  let!(:my_attachment) { create(:attachment, attachable: my_question) }
  let!(:not_my_question) { create(:question) }
  let!(:not_my_attachment) { create(:attachment, attachable: not_my_question) }
  

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    it "deletes other user's question's attachment" do
      expect { delete :destroy, params: { id: not_my_attachment } }.to_not change(Attachment, :count)
    end
    it "deletes own question's attachment" do
      my_question
      my_attachment
      expect { delete :destroy, params: { id: my_attachment } }.to change(Attachment, :count)
    end

  end
end