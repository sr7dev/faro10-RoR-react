class Api::V1::Clinicians::MembersController < Api::Controller
  # Member approving Clinician Relationship Request
  def approve
    @membership = Membership.find_by(member_id: current_user.id, clinician_id: params[:clinician_id])

    if @membership
      consent_signature = params[:params][:consent_signature]
      begin
        authorize! :accept, @membership
        AcceptMembershipService.new(membership: @membership, consent_signature: consent_signature).perform
        render json: @membership, status: :ok
      rescue StandardError => e
        render json: {errors: e.message}, status: :unprocessable_entity
      end
    else
      render json: { status: :not_found }
    end
  end

  # Member or Clinician destroying relationship
  def destroy
    if current_user.type == "Clinician"
      @membership = Membership.find_by(member_id: params[:id], clinician_id: current_user.id)
    else
      @membership = Membership.find_by(member_id: current_user.id, clinician_id: params[:id])
    end

    if @membership
      begin
        authorize! :cancel, @membership
        CancelMembershipService.new(membership: @membership).perform
        render json: { status: :ok }
      rescue StandardError => e
        render json: {errors: e.message}, status: :unprocessable_entity
      end
    else
      render json: { status: :not_found }
    end
  end
end
