FactoryGirl.define do
  factory Question do
    user
    sequence(:title) { |n| "Question title ##{n}" }
    sequence(:body) { |n| "Question body ##{n}" }

    trait :invalid do
      title ''
    end
  end
end
