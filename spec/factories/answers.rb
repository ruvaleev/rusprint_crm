FactoryBot.define do
  factory :answer do
    user
    question
    body "MyText first"
  end

  factory :another_answer, class: "Answer" do
    user
    question
    body "MyText another"
  end

  factory :invalid_answer, class: "Answer" do
    user
    question
    body nil
  end
end
