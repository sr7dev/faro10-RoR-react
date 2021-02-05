class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :join, :edit, :update, :destroy]
  around_action :set_time_zone


  def index
    @meetings = Meeting.all
    # @host = User.find(user_id: id)
    @recommended = Channel.all
    @channels= Channel.all
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end

  def vet_meetings
    @meetings = Meeting.where(meeting_type: "Veteran Support")
    @recommended = Channel.all
    @channels= Channel.where(channel_focus: "Veteran Support")
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end

  def substance_meetings
    @meetings = Meeting.where(meeting_type: "Substance Abuse")
    @recommended = Channel.all

    @channels= Channel.where(channel_focus: "Substance Abuse")
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end

  def caregiver
    @meetings = Meeting.where(meeting_type: "Care Giver Support")
    @recommended = Channel.all

    @channels= Channel.where(channel_focus: "Care Giver Support")
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end
  def eating
    @meetings = Meeting.where(meeting_type: "Eating Disorder")
    @recommended = Channel.all
    @channels= Channel.where(channel_focus: "Eating Disorder")
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end
  def suicide_loss
    @meetings = Meeting.where(meeting_type: "Suicide Loss")
    @recommended = Channel.all
    @channels= Channel.where(channel_focus: "Suicide Loss")
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end
  def depression
    @meetings = Meeting.where(meeting_type: "Depression")
    @recommended = Channel.all
    @channels= Channel.where(channel_focus: "Depression")
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end
  def pregnancy_loss
    @meetings = Meeting.where(meeting_type: "Pregnancy Loss")
    @recommended = Channel.all
    @channels= Channel.where(channel_focus: "Pregnancy Loss")
    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse
    @meeting = Meeting.new
  end

  def my_meetings
    @meetings = Meeting.where(user_id: current_user.id)
    @meeting = Meeting.new
  end

  def categories
    @meetings = Meeting.all
    # @host = User.find(user_id: id)
    @recommended_channels= Channel.all

    @channels= Channel.all

    @user = current_user
    @observations = @user.observations_on_me.active
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse

    @meeting = Meeting.new
  end


  def show

    @user = current_user
    @meeting = Meeting.find(params[:id])
    # redirect_to(verify_password_meeting_path(@meeting)) if @meeting.private? && params[:password] != @meeting.password
    # params.delete[:password]
    
    @twilio_token = current_user.twilio_token_json()
    
    @contacts = current_user.observations_on_me.active.each_with_object({}) do |obs, hash|
      hash[obs.observer.user_id] = {
          observer_id: obs.observer_id,
          relationship: obs.relationship,
          meds: obs.meds,
          id: obs.id,
          status: obs.status
      }
    end

    @params = {
      meeting: @meeting,
      user: @user,
      userToken: @user.get_token(),
      twilioToken: @twilio_token,
      rootURL: request.protocol + request.host_with_port,
      contacts: @contacts
    }

    authorize! :read, @meeting

  end

  def verify_password
    @meeting = Meeting.find(params[:id])
  end

  def verify_password_valid
    @meeting = Meeting.find(params[:id])
    redirect_to verify_password_meeting_path @meeting if params[:password] != @meeting.password
    redirect_to meeting_path(@meeting)
  end

  def new         #this is to schedule a meeting in the future
    authorize! :create, Meeting
    @meeting = Meeting.new
  end

  def meet_now   #this is to launch a meeting immediately.  It should create the meeting record in the DB and put the user in the meeting waiting room
    authorize! :create, Meeting
    @meeting = Meeting.new
    @user = current_user
    @observations = @user.observations_on_me.active

  end

  def join
    @mu = MeetingUser.new(meeting: @meeting, user: current_user, display_name: current_user.user_id, email: current_user.email)

    authorize! :join, @meeting
    respond_to do |format|
      if @mu.save
        format.json { render :show, status: :ok, meeting: @meeting }
      else
        format.json { render json: @mu.errors, status: :unprocessable_entity }
      end
    end
  end

  def invite
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      format.ics do
        cal = Icalendar::Calendar.new
        cal.event do |e|
          e.dtstart     = @meeting.start_time
          e.dtend       = @meeting.end_time
          e.location    = "TelaPeer"
          e.summary     = @meeting.name
          e.description = @meeting.meeting_type,
                          @meeting.name,
                          @meeting.topic,
                          @meeting.special_focus,
                          "Log into TelaPeer on your IOS or Browser to join this meeting"
        end
        cal.publish
        send_data cal.to_ical
      end
    end
  end

  def schedule_session   #this is for clinicians to schedule telehealth sessions
    authorize! :create, Meeting
    @meeting = Meeting.new
  end

  # def edit
  # end

  def create
    @user = current_user
    @observations = @user.observations_on_me.active
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      # invitation_params => params[:meeting][:invitations] => [1, 2, 3, 4, 5, 20]
      (params[:user_invitations] || []).each do |user_id|
        MeetingInvitation.create(invited: User.find(user_id), meeting: @meeting, creator: current_user)
      end

      flash[:info] = "Your Meeting has been created."
      redirect_back fallback_location: meetings_url
      # redirect_to meeting_path(@meeting)
    else
      render "new"
    end
  end

  def update
    # meeting = params[:meeting]
    # date = meeting[:date].to_date
    # time = meeting[:time].to_time
    # start_time = Time.parse "#{date} #{time}"
    # @meeting.start_time = start_time

    respond_to do |format|
      if @meeting.update_attributes(meeting_params)

        format.html { redirect_to meetings_path, notice: 'Meeting was successfully updated.' }
        # format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @meeting.destroy
    respond_to do |format|
      format.html { redirect_to meetings_url, notice: 'Meeting was successfully canceled.' }
      format.json { head :no_content }
    end
  end

  private
    def meeting_params
      params.require(:meeting).permit(:id, :name, :meeting_type, :start_time, :end_time, :duration, :created_at, :status,
                                      :room_name, :privacy, :topic, :special_focus, :host, :user_id, :password, :date, :time )
    end

    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def set_time_zone
      Time.use_zone(current_user.time_zone) { yield }
    end

end