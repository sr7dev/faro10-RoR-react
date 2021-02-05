class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def invite_clinician(email)
    mail to: email, subject: "You have recieved an invitation from one of your Patients to join Faro10"
  end

  def invite_observer(email)
    mail to: email, subject: "You have recieved an invitation from a friend"
  end

  def invite_member(email)
    mail to: email, subject: "You have been invited by a friend to join Faro10"
  end

  def meeting_invitation(user)
    @user = user
    mail to: user.email, subject: "You've been invited to a Faro10 meeting"
  end

  def patient_entry_notification(entry, patient, clinician)
    @entry = entry
    @patient = patient
    @clinician = clinician
    membership = @patient.memberships.find_by(clinician_id: @clinician.id)

    if membership.active?
      if @entry.created_at < membership.valid_until
        mail to: clinician.email, subject: "A Patient has recorded a new entry"
      end
    end
  end

  def patient_alert_notification(patient, clinician)
    @patient = patient
    @clinician = clinician
    membership = @patient.memberships.find_by(clinician_id: @clinician.id)

    if membership.active?
      mail to: clinician.email, subject: "A Patient has a new alert"
    end
  end
end
