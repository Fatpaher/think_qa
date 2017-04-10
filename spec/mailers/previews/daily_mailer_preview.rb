# Preview all emails at http://localhost:3000/rails/mailers/daily_mailer
class DailyPreview < ActionMailer::Preview
  def digest
    DailyMailer.digest
  end
end
