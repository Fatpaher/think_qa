require 'rails_helper'

describe SubscriptionMailer, type: :mailer do
  describe '#question' do
    let(:user) { create :user }
    let!(:question) { create :question }
    let!(:answer) { create :answer, question: question }
    let!(:mail) { SubscriptionMailer.question user, answer }

    it 'renders receiver email' do
      expect(mail.to).to include user.email
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'includes link to answer question' do
      expect(mail.body.encoded).to have_link(question.title, href: question_url(question))
    end

    it 'includes answer body' do
      expect(mail.body.encoded).to include(answer.body)
    end
  end
end
