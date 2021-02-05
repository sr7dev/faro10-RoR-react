class AdminMailer < ApplicationMailer
  def clinician_registration(recipient, clinician)
    @clinician = clinician

    mail(
      to: recipient.email, 
      subject: "New clinician has registered"
    )
  end
end
