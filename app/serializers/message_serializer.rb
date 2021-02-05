class MessageSerializer < ActiveModel::Serializer
  attributes :body, :read, :archived, :member_id, :created_at, :updated_at, :id

  has_one :clinician
end
