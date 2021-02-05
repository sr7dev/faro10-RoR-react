class MeetingUser < ApplicationRecord
  belongs_to :user
  belongs_to :meeting

  def self.in_meeting
    where(departed: [false, nil ])
  end

  def remove
    twilio_client.video.rooms(meeting.room_name)
                       .participants(twilio_sid)
                       .update(status: 'disconnected')

    update_attribute(:departed, true)
  end

  def twilio_sid
    participant = retrieve_twilio_participant(meeting, user_id)
    participant.sid
  end

  private

    def retrieve_twilio_participant(meeting, user_id)    
      participant = twilio_client.video.rooms(meeting.room_name)
                  .participants(user_id.to_s).fetch
    end

    def participant_tracks
      participant_tracks = twilio_client.video.rooms(meeting.room_name)
                  .participants(user_id.to_s)
                  .published_tracks.list
    end

    def twilio_client
      api_key_sid = ENV.fetch("TWILIO_ACCOUNT_SID")
      api_key_secret = ENV.fetch("TWILIO_AUTH_TOKEN")
  
      client = Twilio::REST::Client.new api_key_sid, api_key_secret
    end

end
