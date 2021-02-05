class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_FROM_ADDRESS", "Faro10 <noreply@faro10.com>")
  layout 'mailer'
end
