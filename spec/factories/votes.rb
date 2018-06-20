FactoryBot.define do
  factory :vote_for_answer, class: 'Vote' do
    user
    association :object, factory: :answer
  end

  factory :vote_for_question, class: 'Vote' do
    user
    association :object, factory: :question
  end
end
