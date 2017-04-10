require 'rails_helper'

describe Question do
  context 'assosiations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:best_answer).
         conditions(best_answer: true).
         class_name 'Answer'
       }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  it_behaves_like 'Votable'
  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'

  describe '#subscribe_author' do
    let(:user) { create :user }
    let(:question) { build :question, user: user }

    it 'subscribe author to question' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end

    it 'performs when question create' do
      expect(question).to receive(:subscribe_author)
      question.save!
    end
  end
end
