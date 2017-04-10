require 'rails_helper'

describe Answer do
  context 'assosiations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end

  it_behaves_like 'Votable'
  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'

  describe '#select_best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question_id: question.id) }

    it 'returns best answer true value' do
      answer.select_best
      expect(answer).to be_best_answer
    end

    it 'set previos best answer as false' do
      previos_best_answer = create(:answer, :best_answer, question_id: question.id)
      answer.select_best
      previos_best_answer.reload
      expect(previos_best_answer).not_to be_best_answer
    end
  end

  describe '#notify_subscriber' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    subject { build :answer, question: question }

    it 'should notify subscribed users' do
      expect(QuestionNotifierJob).to receive(:perform_later).with(subject)
      subject.save!
    end
  end
end
