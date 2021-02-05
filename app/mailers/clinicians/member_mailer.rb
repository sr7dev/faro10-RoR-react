class Clinicians::MemberMailer < ApplicationMailer

  def membership_renewal_request(membership)
    @member = membership.member
    subject = "A clinician has requested consent on Faro10"

    mail to: @member.email, subject: subject
  end

  def new_appointment(appointment)
    @member = appointment.member
    subject = "A clinician has scheduled an appointment for you on Faro10"

    mail to: @member.email, subject: subject
  end

  def patient_added(membership)
    @member = membership.member
    subject = "A clinician has added you as a patient on Faro10"

    mail to: @member.email, subject: subject
  end

  def patient_invitation(membership, invitation_url)
    @member = membership.member
    @invitation_url = invitation_url
    subject = "A clinician has invited you to Faro10"

    mail to: @member.email, subject: subject
  end
end
