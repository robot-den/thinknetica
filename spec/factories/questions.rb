FactoryGirl.define do
  factory :question do
    title "MyString123456789"
    body "MyString123456789"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
