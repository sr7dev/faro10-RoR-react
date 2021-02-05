class Api::V1::MeetingUsersController < Api::Controller
  before_action :set_meeting, only: [:remove]
  before_action :set_meeting_user, only: [:remove]
  before_action :confirm_meeting_host, only: [:remove]

  def index
    @meeting_users = MeetingUser.where("meeting_id = ?", params[:meeting_id])
    respond_with @meeting_users, each_serializer: MeetingUserSerializer
  end

  def show
    @attendees = MeetingUser.where("meeting_id = ?", params[:meeting_id])
    @attendee = @attendees.find_by(user: params[:id])

    render json: @attendee, serializer: MeetingUserSerializer
  end


  def update
    @attendees = MeetingUser.where("meeting_id = ?", params[:meeting_id])
    @attendee = @attendees.find_by(user: params[:id])


    if @attendee.update_attributes(meeting_user_params)
      respond_with @attendee, serializer: MeetingUserSerializer
    else
      render json: {success: false, errors: @meeting_user.errors}
    end

  end


  def create
    # authorize! :create, MeetingMessage
    @meeting_user = MeetingUser.new(meeting_user_params)

    if @meeting_user.save
      render json: @meeting_user, status: :ok

    else
      render json: @meeting_user.errors.full_messages, status: :unprocessable_entity
    end

  end

  # POST /meetings/:meeting_id/meeting_user/:id/remove
  def remove
    response = @meeting_user.remove

    if response
      render json: {message: 'User removed from meeting'}, status: :ok
    else
      render json: {message: 'User could not be removed from meeting'}, status: :internal_server_error
    end
  end

  private
    def confirm_meeting_host
      unless current_user.user_id == @meeting.host
        render json: {message: "Current user is not meeting host"}, status: 403
      end 
    end

    def set_meeting
      @meeting = Meeting.find(params[:meeting_id])
    end

    def set_meeting_user
      @meeting_user = @meeting.meeting_users.find(params[:id])
    end

    def meeting_user_params
      params.require(:meeting_user).permit(:id, :user_id, :meeting_id, :anonymous, :comfortable_leading, :mood_rating, :raise_hand, :departed, :display_name, :facilitator_rating, :abuse_reported, :email)
    end
end
