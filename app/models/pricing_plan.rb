class PricingPlan < ApplicationRecord
  has_many :clinicians, through: :subscriptions
  has_many :subscriptions

  validates :name, presence: true
end
