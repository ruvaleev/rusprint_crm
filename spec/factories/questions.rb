FactoryBot.define do
  factory :question do

  	user
  	title "MyString"
    body "MyText"
  end

  factory :another_question, class: "Question" do
    user
    title "Another Title"
    body "Another body Body body"
  end

  factory :invalid_question, class: "Question" do
  	user
  	title nil
  	body nil
  end

end
