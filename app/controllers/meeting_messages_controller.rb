class MeetingMessagesController < ApplicationController
  before_action :set_meeting

  def index
    @meeting_messages = MeetingMessage.all
  end

  def edit
    @meeting_message = MeetingMessage.find(params[:id])
    authorize! :update, @meeting_message
  end

  def new
    authorize! :create, MeetingMessage
    @meeting_message = MeetingMessage.new
  end


  def create
    # authorize! :create, MeetingMessage

    @meeting_message = MeetingMessage.new(message_params)
    if @meeting_message.save
      # flash[:success] = "Your Message has been created!"
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
      flash[:danger] = "Failed to create your Message"
    end
  end

  def update
    authorize! :update, @meeting_message
    respond_to do |format|
      if @meeting_message.update_attributes(message_params)
        format.html { redirect_to @meeting_message, notice: 'Channel was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @meeting_message.errors, status: :unprocessable_entity }
      end
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