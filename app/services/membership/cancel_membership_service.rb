class CancelMembershipService
  def initialize(membership:)
    @membership = membership
    @clinician = @membership.clinician
    @member = @membership.member
  end

  def perform
    cancel_all_consents
    deactivate_membership
    email_clinician
    log
  end

  private
    def cancel_all_consents
      now = Time.current
      @membership.consents.where("ended_at > ?", now)
                          .where(canceled_at: nil)
                          .update_all(canceled_at: now)
    end

    def deactivate_membership
      @membership.update_attributes(status: "inactive")
    end

    def email_clinician
      MembershipMailer.delay.cancel(@membership)
    end

    def log
      # TODO
    end
end
