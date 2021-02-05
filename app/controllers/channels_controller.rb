class ChannelsController < ApplicationController

  def index
    @meetings = Meeting.where(user_id: current_user.id)
    @all_channels = Channel.all
    @channels = Channel.where("user_id = ?",current_user.id)
    @channel = Channel.new
    @channel_assets = @channel.channel_assets.build
    @meeting = Meeting.new
  end

  def my_activities
    @meetings = Meeting.where(user_id: current_user.id)
    @channels = Channel.where("user_id = ?",current_user.id)
    @channel = Channel.new
    @channel_assets = @channel.channel_assets.build
    @meeting = Meeting.new
  end



  def show
    @channels = Channel.where("user_id = ?",current_user.id)
    @channel = Channel.find(params[:id])

    @channel_assets = @channel.channel_assets

    @first_video = @channel_assets.is_video?.first


    # @scheduled_meetings = Meeting.scheduled.where("user_id = ?", @channel.user_id)
    @community_meetings = Meeting.scheduled.where("meeting_type = ?", @channel.channel_focus)

    @meeting_messages = MeetingMessage.all
    @channel_messages = @meeting_messages.where("meeting_id = ?", @channel.meeting_id)

    @meeting = @channel.meeting

    @channel_message = @meeting.meeting_messages.new

    @channel_followers = @meeting.meeting_users

    @following = MeetingUser.where(meeting: @meeting, user_id: current_user.id)

  end

  def follow
    @meeting = Meeting.find(params[:id])
    # @meeting = @channel.find(params[:meeting_id])
    # @meeting = @channel.meeting

    @mu = MeetingUser.new(meeting: @meeting, user_id: current_user.id)
    authorize! :follow, @meeting
    respond_to do |format|
      if @mu.save
        format.html { redirect_to channel_path(@meeting.channel) }
      else
        format.json { render json: @mu.errors, status: :unprocessable_entity }
      end
    end
  end

  def unfollow
    @meeting = Meeting.find(params[:id])

    @mu = MeetingUser.find_by(meeting: @meeting, user: current_user)
    authorize! :follow, @meeting
    respond_to do |format|
      if @mu.destroy
        format.html { redirect_to channel_path(@meeting.channel) }
        # format.json { render :show, status: :ok, meeting: @meeting }
      else
        format.json { render json: @mu.errors, status: :unprocessable_entity }
      end
    end
  end

  def new                    #   When creating a channel, a meeting also has to be created that is dedicated to this channel
    authorize! :create, Channel
    @channel = Channel.new
    @channel_assets = @channel.channel_assets.build
  end

  def edit
    @channel = Channel.find(params[:id])
    @channel_assets = @channel.channel_assets
    authorize! :update, @channel
  end

  def create
    authorize! :create, Channel
    @channel = CreateChannelService.new(current_user, channel_params).perform

    if @channel.persisted?

      flash[:success] = "Your Community has been created!"
      redirect_to my_activities_url
    else
      redirect_to my_activities_url
      flash[:danger] = "Failed to create your Community"
    end
  end

  def update
    authorize! :update, Channel
    @channel = Channel.find(params[:id])
    respond_to do |format|
      if @channel.update_attributes(channel_params)
        format.html { redirect_back fallback_location: root_path, notice: 'Community was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @channel = Channel.find(params[:id])

    authorize! :destroy, @channel

    if @channel.present?
      @channel.destroy
    end
    respond_to do |format|
      format.html { redirect_to my_activities_url, notice: 'Community was successfully canceled.' }
      format.json { head :no_content }
    end
  end



  private

  def set_meeting
    @meeting = Meeting.find(channel_params[:meeting_id])
  end

  def channel_params
      params.require(:channel).permit(:channel_name, :user_id, :owner_detail, :channel_focus, :meeting_id, :avatar, :is_partner, :about,
                                      channel_assets_attributes: [:id, :asset_type, :source, :asset_name, :description, :channel_id, :user_id, :_destroy])
  end

end

