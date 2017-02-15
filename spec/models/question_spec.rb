require 'rails_helper'

describe Question do
  context 'assosiations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:right_answer).
         class_name(Answer).
         with_foreign_key('right_answer_id')
       }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
