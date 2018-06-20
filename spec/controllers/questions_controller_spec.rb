require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end 

  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saved the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
      it "question's user_id equal user's id" do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq(@user.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    sign_in_user
    context 'valid attributes' do
      it 'assigns the requested question to @question' do 
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end     

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'} }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil} }, format: :js }
      
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:own_question) { create(:question, user: user) }

    before(:each, deletes_own_question: :true) do
      sign_in(user)
      own_question
    end

    it "deletes other user's question" do
      question
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
    end

    it 'deletes own question', deletes_own_question: :true do
      expect { delete :destroy, params: { id: own_question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view', deletes_own_question: :true do
      expect(delete :destroy, params: { id: own_question }).to redirect_to questions_path
    end
  end

  describe 'PATCH #create_vote' do
    let!(:votable_question) { create(:question) }
    let(:vote_for_question) { create(:vote_for_question, user: user, object: votable_question, value: 1) }
    before { sign_in(user) }

    it "creates vote for question" do
      expect { patch :create_vote, params: { id: votable_question, value: 1, format: :json } }.to change(Vote, :count).by(1)
    end

    it "deletes vote for question" do
      vote_for_question
      expect { patch :create_vote, params: { id: votable_question, value: 1, format: :json } }.to change(Vote, :count).by(-1)
    end

    it "it retrieves success response after voting for question" do
      patch :create_vote, params: { id: votable_question, value: 1, format: :json }
      expect(response).to be_success
    end

  end
end