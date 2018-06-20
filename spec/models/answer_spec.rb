require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:own_answer) { create(:answer, question: question, user: user) }
  let!(:former_best_answer) { create(:answer, question: question, award: true) }
  let!(:votes_for_answer) { create_list(:vote_for_answer, 4, object: answer, value: 1) }
  let!(:vote_against_answer) { create(:vote_for_answer, object: answer, value: -1) }

  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should have_many :attachments }
  it { should have_many(:comments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }

  it 'makes best' do
    answer.make_best
    expect( answer.award ).to be_truthy 
  end

  it 'former best answer is not the best now' do
    answer.make_best
    former_best_answer.reload
    expect( former_best_answer ).to_not be_award
  end

  it 'return rating of answer' do
    expect( answer.rating ).to eq(3)
  end

  it 'can be voted' do
    answer.vote(user, 1)
    expect( answer.rating ).to eq(4)
  end

  it "will be deleted when trying to be voted twice" do
    2.times { answer.vote(user, 1) }
    expect( answer.rating ).to eq(3)
  end

end