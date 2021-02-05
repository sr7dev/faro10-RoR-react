class MeetingSerializer < ActiveModel::Serializer
  attributes :id, :name, :meeting_type, :start_time, :end_time, :duration, :status, :room_name, :privacy, :topic, :special_focus, :host, :user_id, :password, :attendee_count



  def attendee_count
    # @meetings = Meeting.all
    @attendee_count = MeetingUser.in_meeting.count

    # result = @meetings.each do |meeting|
    #     meeting.meeting_users.in_meeting.count
    # end
    #
    # respond_with result

  end
end


