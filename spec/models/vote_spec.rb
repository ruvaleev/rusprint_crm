require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:answers_author) { create(:user) }
  let!(:answer) { create(:answer, user: answers_author) }
  let!(:user) { create(:user) }
  let!(:vote) { create(:vote_for_answer, user: user, object: answer, object_type: 'Answer', value: 1) }
  
  it { should belong_to :object }
  it { should belong_to :user }

  it 'validate_uniqueness_of user, object and object_type' do
    duplicate_vote = Vote.create(user: user, object: answer, object_type: 'Answer', value: 1)
    expect(duplicate_vote).not_to be_valid
    expect(duplicate_vote.errors.first[1]).to eq('has already been taken')
  end

  it 'author cannot vote for own answer/question' do
    vote_for_own_answer = Vote.create(user:answers_author, object: answer, object_type: 'Answer', value: 1)
    expect(vote_for_own_answer).not_to be_valid
    expect(vote_for_own_answer.errors.first[1]).to eq("You can't vote for own Answer")
  end
end
