# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview
  def question
    SubscriptionMailer.question(user, answer)
  end
end
