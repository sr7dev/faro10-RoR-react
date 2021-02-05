class Membership < ApplicationRecord
  belongs_to :clinician
  belongs_to :member
  has_many :consents, dependent: :destroy

  scope :ordered_by_member_name, -> { joins(:member).order("LOWER(users.user_id)") }
  scope :active, -> { where(status: "active") }
  scope :active_at, -> (time){ joins(:consents).merge(Consent.active_at(time)).uniq }
  scope :active_during, ->(daterange){ joins(:consents).merge(Consent.active_during(daterange)).uniq }
  scope :inactive, -> { where(status: "inactive") }
  scope :pending, -> { where(status: "pending") }
  scope :pending_or_inactive, -> { where('status = ? OR status = ?', "inactive", "pending")}
  scope :journal_visible?, -> { where(journal_visible: true) }
  scope :journal_hidden?, -> { where.not(journal_visible: true) }

  validates :clinician, presence: true
  validates :member, presence: true
  validates :member_id, uniqueness: {scope: :clinician_id}
  validates :status, inclusion: {in: %w(active inactive pending)}

  attr_accessor :email

  def active?
    status == "active"
  end

  def active_at(time)
    valid_until > time
  end

  def inactive?
    status == "inactive"
  end

  def pending?
    status == "pending"
  end

  def is_valid?
    active? && valid_consent?
  end

  def valid_consent?
    consents.where('ended_at > ?', Time.now).where(canceled_at: nil).any?
  end

  def valid_until
    if consents.any?
      if self.active?
        consents.order(:created_at).last.ended_at
      else
        consents.order(:created_at).last.canceled_at
      end
    else
      Time.new(0)
    end
  end
end
