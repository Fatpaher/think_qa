FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@.example.com" }
    sequence(:password) { |n| "secure_password#{n}" }
  end
end
