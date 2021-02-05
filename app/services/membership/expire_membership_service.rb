class ExpireMembershipService
  def initialize(membership:)
    @membership = membership
    @clinician = @membership.clinician
    @member = @membership.member
  end

  def perform
    deactivate_membership
    email_clinician
    log
  end

  private
    def deactivate_membership
      @membership.update_attributes(status: "inactive")
    end

    def email_clinician
      MembershipMailer.delay.expired(@membership)
    end

    def log
      # TODO
    end
end
