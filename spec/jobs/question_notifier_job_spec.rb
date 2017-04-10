require 'rails_helper'

describe QuestionNotifierJob, type: :job do
  let!(:unsubscribed_user) { create :user }
  let!(:author) { create :user }
  let!(:user) { create :user }
  let(:question) { create :question, user: author }
  let!(:subscription) { create :subscription, question: question, user: author }
  let!(:subscription) { create :subscription, question: question, user: user }
  let(:answer) { create :answer, question: question }

  it 'sends notifications about new answer to subscribed user' do
    expect(SubscriptionMailer).to receive(:question).with(author, answer).and_call_original
    expect(SubscriptionMailer).to receive(:question).with(user, answer).and_call_original
    QuestionNotifierJob.perform_now(answer)
  end

  it 'not send notification to unsubscribed user' do
    expect(SubscriptionMailer).not_to receive(:question).with(unsubscribed_user, answer).and_call_original
    QuestionNotifierJob.perform_now(answer)
  end
end
