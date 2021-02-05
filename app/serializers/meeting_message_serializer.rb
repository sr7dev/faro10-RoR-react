class MeetingMessageSerializer < ActiveModel::Serializer
  attributes :body, :id, :meeting_id, :message_id, :created_at, :updated_at, :attendee_id, :attendee_name
end
