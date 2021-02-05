class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :clinician_id
  has_one :pricing_plan
end
