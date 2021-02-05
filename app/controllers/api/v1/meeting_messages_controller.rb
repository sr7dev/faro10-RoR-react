class Api::V1::MeetingMessagesController < Api::Controller
  before_action :set_meeting

  def index

    @meeting_messages = MeetingMessage.where("meeting_id = ?", params[:meeting_id])
    respond_with @meeting_messages, each_serializer: MeetingMessageSerializer


  end


  def create
    # authorize! :create, MeetingMessage
    @meetingmessage = MeetingMessage.new(message_params)

    if @meetingmessage.save
      render json: @meetingmessage, status: :ok

    else
      render json: @meetingmessage.errors.full_messages, status: :unprocessable_entity
    end

  end


  private
    def set_meeting
      @meeting = Meeting.find(params[:meeting_id])
    end

    def message_params
      params.require(:meeting_message).permit(:body, :id, :meeting_id, :message_id, :created_at, :updated_at, :attendee_id, :attendee_name)
    end
end
