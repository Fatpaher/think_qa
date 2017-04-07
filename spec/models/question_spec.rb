require 'rails_helper'

describe Question do
  context 'assosiations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:best_answer).
         conditions(best_answer: true).
         class_name 'Answer'
       }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  it_behaves_like 'Votable'
  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'
end
