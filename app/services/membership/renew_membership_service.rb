class RenewMembershipService
  def initialize(membership:, consent_signature: nil)
    @membership = membership
    @consent_signature = consent_signature
    @clinician = @membership.clinician
    @member = @membership.member
  end

  def perform
    create_consent
    activate_membership
    email_clinician
    log
  end

  private
    def activate_membership
      @membership.update_attributes(status: "active")
    end

    def create_consent
      @consent = Consent.create(membership: @membership,
                                signature: @consent_signature,
                                ended_at: Time.current + Consent::DEFAULT_LENGTH)

      @consent_pdf = GeneratePdfService.new(template: 'consents/show', locals: {consent: @consent}).perform
    end

    def email_clinician
      MembershipMailer.delay.renew(@membership, @consent_pdf)
    end

    def log
      # TODO
    end
end
