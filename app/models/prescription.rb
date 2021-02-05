class Prescription < ApplicationRecord
  belongs_to :member
  belongs_to :drug

  has_many :entries_prescriptions

  validates :drug_id, presence: true
  validates :member_id, presence: true
  validates :started, presence: true
  validates :dosage, presence: true
  validates :dosage, numericality: true

  scope :current, -> { where(ended: nil) }
  scope :visible_to, -> (clinician){ joins(member: :memberships).where(memberships: {clinician_id: clinician.id}).merge(Membership.active) }

  def display_reminder
    case reminder
    when 1
      "Hourly"
    when 24
      "Daily"
    when 12
      "Twice a Day"
    else
      ""
    end
  end

  def self.expired
    where.not(ended: nil)
  end

  def self.unexpired
    where(ended: nil)
  end

  def daily_doses
    case reminder
      when 24 then 1
      when 12 then 2
      else 24
    end
  end

  def total_times_taken
    EntriesPrescription.where(prescription: self).sum(:times_taken)
  end

  def duration
    end_date = ended ? ended.to_date : Date.today
    dur = (end_date - started.to_date).to_i
    dur.zero? ? 1 : dur
  end

  def consistency
    ((total_times_taken.to_f / (daily_doses * duration)) * 100).round
  end
end
