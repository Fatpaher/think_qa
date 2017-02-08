FactoryGirl.define do
  factory Answer do
    question
    sequence(:body) { |n| "Answer body ##{n}" }

    trait :invalid do
      body ''
    end
  end
end
