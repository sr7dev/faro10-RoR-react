class MeetingInvitationSerializer < ActiveModel::Serializer
  attributes :id, :meeting_id, :creator_id, :invited_id, :created_at, :updated_at
end
