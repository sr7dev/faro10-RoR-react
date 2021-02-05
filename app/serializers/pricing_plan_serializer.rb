class PricingPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :stripe_id, :interval, :amount
end
