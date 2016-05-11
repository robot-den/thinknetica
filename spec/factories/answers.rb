FactoryGirl.define do
  factory :answer do
    body "MyText123456789"
    question
    user
    best false

    trait :with_attachment do
      after(:create) do |answer|
        create(:attachment, attachable: answer)
      end
    end
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
