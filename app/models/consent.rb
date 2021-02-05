class Consent < ApplicationRecord
  belongs_to :membership

  delegate :member, to: :membership
  delegate :clinician,to: :membership

  DEFAULT_LENGTH = 1.year

  scope :active, -> { active_at(Time.zone.now) }
  scope :active_at, ->(time) { where("canceled_at > ? OR canceled_at IS ?", time, nil)
                              .where("ended_at > ?", time) }
  scope :active_during, ->(daterange) { where("consents.created_at <= ?", daterange.last)
                                       .where("canceled_at >= ? OR canceled_at IS ?", daterange.first, nil)
                                       .where("ended_at >= ?", daterange.first) }
  scope :canceled, -> { canceled_at(Time.zone.now) }
  scope :canceled_at, ->(time) { where("canceled_at <= ?", time) }
  scope :canceled_during, ->(daterange) { where(canceled_at: daterange) }
  scope :expired, -> { expired_at(Time.zone.now) }
  scope :expired_at, ->(time) { where(canceled_at: nil)
                               .where("ended_at <= ?", time) }
  scope :expired_during, ->(daterange) { where(ended_at: daterange)
                                        .where.not(canceled_at: daterange) }

  validates :membership, presence: true

  def active?
    status == "active"
  end

  def expired?
    status == "expired"
  end

  def started_at
    created_at
  end

  def status(as_of = Time.zone.now)
    if canceled_at.present?
      "canceled"
    elsif as_of > ended_at
      "expired"
    else
      "active"
    end
  end

end
