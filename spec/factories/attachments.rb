FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'files', 'test.txt')) }

    trait :for_question do
      association :attachable, factory: :question
      attachable_type 'Question'
    end
    trait :for_answer do
      association :attachable, factory: :answer
      attachable_type 'Answer'
    end
  end
end
