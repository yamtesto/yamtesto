class Emailer < ActionMailer::Base
  include ApplicationHelper # strange; can't figure out why this is not included
  def confirmation(recipient, sent_at = Time.now)
    @subject = 'Confirm YamTesto Account'
    @recipients = recipient.email
    @from = 'yamtesto@gmail.com'
    @sent_on = sent_at
    @body[:user] = recipient
    @body[:host] = host
    # @body[:confirmation] = :something
    @headers = {}
  end
end
