FactoryGirl.define do
  factory :answer do
    body "MyText123456789"
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
