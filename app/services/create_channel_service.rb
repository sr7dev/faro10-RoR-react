class CreateChannelService

  def initialize(current_user, channel_params={})
    @channel_params = channel_params
    @user = current_user
  end

  def perform
    create_channel
    @channel
  end

  private

  def create_channel
    create_meeting

    @channel = Channel.new(@channel_params)
    @channel.meeting = @meeting
    @channel.save!
  end

  def create_meeting
    @meeting = Meeting.new(meeting_type: "channel", user_id: @user.id, start_time: Time.current)
    @meeting.save!
  end

end