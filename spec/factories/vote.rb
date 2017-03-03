FactoryGirl.define do
  factory :vote do
    user
    value 1

    trait :invalid do
      value 2
    end
    trait :for_question do
      association :votable, factory: :question
      votable_type 'Question'
    end
    trait :for_answer do
      association :votable, factory: :answer
      votable_type 'Answer'
    end
  end
end
