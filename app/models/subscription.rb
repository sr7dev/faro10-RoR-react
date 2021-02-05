class Subscription < ApplicationRecord
  belongs_to :pricing_plan
  belongs_to :clinician

  scope :active, -> { where(status: "active") }
  scope :all_except, ->(subscription) { where.not(id: subscription) }
  scope :canceled, -> { where(status: "canceled") }

  delegate :amount, :interval, :name, to: :pricing_plan

  def cancel
    update_attributes(status: "canceled", canceled_at: Time.current, ended_at: Time.current)
  end

  def self.cancel
    update_all(status: "canceled", canceled_at: Time.current, ended_at: Time.current)
  end

  def plan
    pricing_plan
  end
end
