class ObservationSerializer < ActiveModel::Serializer
  attributes :id, :observer_id, :relationship, :guardian, :meds, :status
end
