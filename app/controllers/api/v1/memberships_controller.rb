class Api::V1::MembershipsController < Api::Controller
  def index
    respond_with current_user.memberships, each_serializer: MembershipSerializer
  end

  def update
    membership = Membership.find(params[:id])
    authorize! :update, membership

    begin
      case membership_params[:action]
      when "accept"
        authorize! :accept, membership
        AcceptMembershipService.new(
          membership: membership,
          consent_signature: params[:params][:consent_signature]
        ).perform
      when "deny"
        authorize! :deny, membership
        DenyMembershipService.new(membership: membership).perform
      when "cancel"
        authorize! :cancel, membership
        CancelMembershipService.new(membership: membership).perform
      when "renew"
        authorize! :renew, membership
        RenewMembershipService.new(
          membership: membership,
          consent_signature: params[:params][:consent_signature]
        ).perform
      else
        raise StandardError, "Invalid Action"
      end
      render json: membership, status: :ok
    rescue StandardError => e
      render json: {errors: e.message}, status: :unprocessable_entity
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:status, :action)
    end
end
