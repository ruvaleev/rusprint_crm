require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:another_answer) { create(:another_answer, question: question) }

  describe "POST #create" do
    sign_in_user
    context "create with valid attributes" do
      it "saves the new answer into the database" do        
      expect { post :create, params: { question_id: question,answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it "saves the new answer with an attributes of user" do
        post :create, params: { question_id: question,answer: attributes_for(:answer), format: :js }
        expect(answer.user_id).to eq(user.id)
      end

      it "saves the new answer with an attributes of question" do
        post :create, params: { question_id: question,answer: attributes_for(:answer), format: :js }
        expect(answer.question_id).to eq(question.id)
      end

      it "redirects to question path" do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        redirect_to question_path(assigns(:question))
      end
    end

    context "create with invalid attributes" do
      let(:invalid_answer) { build(:invalid_answer, question: question, user_id: user.id, format: :js) }
      it "doesn't save a new answer into the database" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it "re-renders new view" do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        redirect_to question_path(assigns(:question))
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    it "deletes other user's answer" do
      another_answer
      expect { delete :destroy, params: { question_id: question, id: another_answer }, format: :js }.to_not change(Answer, :count)
    end

    it 'deletes own answer' do
      sign_in(user)
      answer
      expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end


    it 'it retrieves success response after destroy answer' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    sign_in_user
    
    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do 
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end     

      it 'changes answer attributes' do
        sign_in(user)
        put :update, params: { id: answer, question_id: question, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #create_vote' do
    let(:vote_for_answer) { create(:vote_for_answer, user: user, object: another_answer, value: 1) }
    before { sign_in(user) }

    it "creates vote for answer" do
      expect { patch :create_vote, params: { id: another_answer, value: 1, format: :json } }.to change(Vote, :count).by(1)
    end

    it "deletes vote for answer" do
      vote_for_answer
      expect { patch :create_vote, params: { id: another_answer, value: 1, format: :json } }.to change(Vote, :count).by(-1)
    end

    it "it retrieves success response after voting for answer" do
      patch :create_vote, params: { id: answer, value: 1, format: :json }
      expect(response).to be_success
    end

  end

end