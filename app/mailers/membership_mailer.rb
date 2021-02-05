class MembershipMailer < ApplicationMailer
  
  def accept(membership, consent_pdf)
    @membership = membership
    @clinician = @membership.clinician
    @consent_pdf = consent_pdf

    attachments["consent.pdf"] = @consent_pdf

    mail to: @clinician.email, subject: "A patient has accepted membership on Faro10"
  end

  def renew(membership, consent_pdf)
    @membership = membership
    @clinician = @membership.clinician
    @consent_pdf = consent_pdf

    attachments["consent.pdf"] = @consent_pdf

    mail to: @clinician.email, subject: "A patient has renewed their membership on Faro10"
  end

  def expired(membership)
    @membership = membership
    @clinician = @membership.clinician

    mail to: @clinician.email, subject: "A patient membership has expired on Faro10"
  end

  def membership_expired_by_system(membership)
    @membership = membership
    @member = @membership.member

    mail to: @member.email, subject: "Clinician consent has expired in Faro10"
  end

  def deny(membership)
    @membership = membership
    @clinician = @membership.clinician

    mail to: @clinician.email, subject: "A patient has denied a request for membership on Faro10"
  end

  def cancel(membership)
    @membership = membership
    @clinician = @membership.clinician

    mail to: @clinician.email, subject: "A patient has canceled membership on Faro10"
  end
end
