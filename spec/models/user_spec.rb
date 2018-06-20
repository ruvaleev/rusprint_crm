require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:comments).dependent(:destroy) }

  let!(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:another_answer) { create(:answer, question: question) }
  let(:another_question) { create(:question) }
  let!(:vote_for_answer) { create(:vote_for_answer, object: another_answer, user: user, value: 1, object_type: 'Answer')}
  let!(:vote_for_question) { create(:vote_for_question, object: another_question, user: user, value: 1, object_type: 'Question')}

  it 'user authority on another_answer' do
    expect( user.author_of?(another_answer) ).to be_falsey 
  end
  
  it 'user authority on own answer' do
    expect( user.author_of?(answer) ).to be_truthy 
  end

  it 'user voted or not for answer' do
    expect( user.voted?(another_answer, 1) ).to be_truthy
  end

  it 'user voted or not for question' do
    expect( user.voted?(another_question, 1) ).to be_truthy
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user is already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email }) }
        
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: 'not_existed_user@mail.com' }) }
        
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it "fills user's email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end
        
        it 'creates authorization for new user'do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

end
