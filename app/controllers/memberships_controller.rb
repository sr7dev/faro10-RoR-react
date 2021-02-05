class MembershipsController < ApplicationController
  def create
    authorize! :create, Membership
    @member = Member.find_by(email: membership_params[:email])

    if @member
      if RequestMembershipService.new(clinician: current_user, member: @member).perform
        flash[:success] = "Requested patient to sign consent release."
      else
        flash[:danger] = "Patient could not be added."
      end
    else
      flash[:danger] = "Could not find patient with that email address."
    end
    redirect_back fallback_location: root_path
  end

  def update
    @membership = Membership.find(params[:id])

    begin
      case params[:membership_action]
      when "request"
        authorize! :request, @membership
        RequestMembershipService.new(clinician: current_user, member: @membership.member).perform
        flash[:success] = "Consent requested for #{@membership.member.user_id}."
      when "accept"
        authorize! :accept, @membership
        AcceptMembershipService.new(membership: @membership, 
                                    consent_signature: params[:consent_signature]).perform
        flash[:success] = "Clinician added to treatment team."
      when "deny"
        authorize! :deny, @membership
        DenyMembershipService.new(membership: @membership).perform
        flash[:danger] = "Clinician membership request denied."
      when "cancel"
        authorize! :cancel, @membership
        CancelMembershipService.new(membership: @membership).perform
        flash[:danger] = "Clinician removed from treatment team."
      when "renew"
        authorize! :renew, @membership
        RenewMembershipService.new(membership: @membership,
                                   consent_signature: params[:consent_signature]).perform
        flash[:success] = "Consent renewed for #{@membership.clinician.user_id}."
      else
        new StandardError "Invalid Action"
      end
      redirect_back fallback_location: root_path, success: "Success"
    rescue StandardError => e
      redirect_back fallback_location: root_path, error: "Error"
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:email)
    end
end
