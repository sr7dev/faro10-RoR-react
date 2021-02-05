class RequestMembershipService

  def initialize(clinician:, member:, invitation_url:nil)
    @clinician = clinician
    @member = member
    @invitation_url = invitation_url
    @membership = Membership.find_by(clinician_id: @clinician.id, member_id: @member.id)
  end

  def perform
    if @membership.present?
      @membership.status = "pending"
      @membership.save
      email_member("renewal")
      log("renewal")
    else
      create_membership
      if @member.invitation_created_at && !@member.invitation_accepted_at
        email_member("invite")
        log("invite")
      else
        email_member("add")
        log("add")
      end
    end
    @membership
  end

  private
    def create_membership
      @membership = Membership.create(clinician_id: @clinician.id, member_id: @member.id, status: "pending")
    end

    def email_member(action)
      if action == "add"
        Clinicians::MemberMailer.delay.patient_added(@membership)
      elsif action == "invite"
        Clinicians::MemberMailer.delay.patient_invitation(@membership, @invitation_url)
      else
        Clinicians::MemberMailer.delay.membership_renewal_request(@membership)
      end
    end

    def log(action)
      # TODO
    end
end
