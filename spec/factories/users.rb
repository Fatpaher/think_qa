FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@.example.com" }
    sequence(:password) { |n| "secure_password#{n}" }
    confirmed_at DateTime.now

    trait :admin do
      admin true
    end
  end
end
