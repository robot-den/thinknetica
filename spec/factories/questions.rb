FactoryGirl.define do
  factory :question do
    title "MyTitle123456789"
    body "MyBody123456789"
    user

    trait :with_attachment do
      after(:create) do |question|
        create(:attachment, attachable: question)
      end
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
