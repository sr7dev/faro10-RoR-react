class MessageMailer < ApplicationMailer
  def message_sent(msg)
    @msg = msg
    @member = msg.member

    mail to: @member.email, subject: "You've got mail!"
  end
end
