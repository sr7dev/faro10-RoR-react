class Api::V1::MeetingInvitationsController < Api::Controller


  def create
    @meeting_invitation = MeetingInvitation.new(meeting_invitation_params)
    respond_to do |format|
      if @meeting_invitation.save
        format.html { redirect_to @meeting_invitation, notice: 'Invitations Sent.' }
        format.json { render json: {}, status: :ok, location: @meeting_invitation }
      else
        format.html { render :edit }
        format.json { render json: @meeting_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def meeting_invitation_params
    params.require(:meeting_invitation).permit(:id, :meeting_id, :creator_id, :invited_id, :created_at, :updated_at)
  end


end
