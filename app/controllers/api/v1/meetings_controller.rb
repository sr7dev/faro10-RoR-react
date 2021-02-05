class Api::V1::MeetingsController < Api::Controller
  before_action :set_meeting, only: [:join]

  def index
    @meetings = Meeting.all
    render :json => @meetings
  end


  def create
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      (params[:user_invitations] || []).each do |user_id|
        MeetingInvitation.create(invited: User.find(user_id), meeting: @meeting, creator: current_user)
      end
      render json: @meeting, status: :created
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end


  def invite_users
    # TODO: take care of the scenario where an id in the "user_invitations" array is not a valid user
    # User.find(params[:user_invitations]).each do |user|
    # ... (create the invitation)
    # end
    @meeting = Meeting.find(params[:id])

    (params[:user_invitations]).each do |user_id|
      invite = MeetingInvitation.find_or_initialize_by(invited: User.find(user_id), meeting: @meeting, creator: current_user)
      if invite.persisted?
        invite.send_invitation
      else
        invite.save!
      end
    end
    render json: {}, status: :created
  end

  def join
    @mu = MeetingUser.new(meeting: @meeting, user: current_user, display_name: current_user.user_id, email: current_user.email)

    if @mu.save
      render json: @meeting, status: :joined
    else
      render json: @meeting, status: :failed_to_join
    end
  end

  def remove_participant
    @attendees = MeetingUser.where("meeting_id = ?", params[:meeting_id])
    @attendee = @attendees.find_by(user: params[:id])

  end

  def verify_password
    @meeting = Meeting.find(params[:id])
  end

  def verify_password_valid
    @meeting = Meeting.find(params[:id])

    puts params[:meeting][:password]
    puts params
    
    if params[:meeting][:password] != @meeting.password
      render json: { "is_valid" => false }
    else
      render json: { "is_valid" => true }
    end
  end

  def meeting_user
    @attendees = MeetingUser.where("meeting_id = ?", params[:meeting_id])

    render json: @attendees
  end


  def update
    @meeting = Meeting.find(params[:id])
    authorize! :update, @meeting
    if @meeting.update_attributes(meeting_params)
      respond_with @meeting, serializer: MeetingSerializer
    else
      render json: {success: false, errors: @meeting.errors}
    end
  end


  private
    def meeting_params
      params.require(:meeting).permit(:id, :name, :meeting_type, :start_time, :end_time, :duration, :status, :room_name,
                                      :privacy, :topic, :special_focus, :host, :user_id, :display_name, :password )
    end

    def set_meeting
      @meeting = Meeting.find(params[:id])
    end
end
