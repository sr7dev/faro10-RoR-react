class MeetingInvitationsController < ApplicationController


  def create
    # @meeting = Meeting.find(id: params[:meeting_id])   ---  this didn't work
    # @meeting = Meeting.where("id = ?", params[:meeting_id])  ---  this didn't work
    # @meeting = Meeting.find( meeting_id: params[:id])   ---  this didn't work
    # @meeting = Meeting.where("meeting_id = ?", params[:id])   ---  this didn't work


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
