class MeetingUserSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :meeting_id, :anonymous, :comfortable_leading, :mood_rating, :raise_hand, :display_name, :departed, :abuse_reported, :email
end
