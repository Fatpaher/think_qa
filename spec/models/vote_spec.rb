require 'rails_helper'

describe Vote do
  context 'assosiations' do
    it { is_expected.to belong_to(:votable) }
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    it { is_expected.to validate_inclusion_of(:value).
         in_array(Vote::VOTE_VALUE) }
  end

  context 'votable rating' do
    context 'question' do
      let(:question) { create(:question) }
      it 'increase rating of when created' do
        expect{ create(:vote, votable: question) }.to change{ question.rating }.by(1)
      end
      it 'decrease rating of when destroy' do
        vote = create(:vote, votable: question)
        expect{ vote.destroy }.to change{ question.rating }.by(-1)
      end
    end

    context 'answer' do
      let(:answer) { create(:answer) }
      it 'increase rating of when created' do
        expect{ create(:vote, votable: answer) }.to change{ answer.rating }.by(1)
      end
      it 'decrease rating of when destroy' do
        vote = create(:vote, votable: answer)
        expect{ vote.destroy }.to change{ answer.rating }.by(-1)
      end
    end
  end
end
