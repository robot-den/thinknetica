FactoryGirl.define do
  factory :vote do
    user
    value 0

    trait :up do
      value 1
    end

    trait :down do
      value -1
    end
  end
end
