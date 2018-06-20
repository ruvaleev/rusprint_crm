require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe "POST #create" do
    
    context 'Authorized user' do
      sign_in_user
    
      it 'creates with valid attributes' do
        expect { post :create, params: { user: user, answer_id: answer, comment: { body: 'Test comment' }, format: :js } }.to change(answer.comments, :count).by(1)
      end

      it 'creates with empty body field' do
        expect { post :create, params: { user: user, answer_id: answer, comment: { body: '' }, format: :js } }.to_not change(answer.comments, :count)
      end
    
    end

    context 'Unauthorized user' do
    
      it ' trying to create comment' do
        expect { post :create, params: { user: user, answer_id: answer, comment: { body: 'Test comment' }, format: :js } }.to_not change(answer.comments, :count)
      end
    
    end
  end

end
