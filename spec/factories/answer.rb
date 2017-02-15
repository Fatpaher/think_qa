FactoryGirl.define do
  factory Answer do
    question
    user
    sequence(:body) { |n| "Answer body ##{n}" }

    trait :invalid do
      body ''
    end

    trait :best_answer do
      best_answer true
    end
  end
end
