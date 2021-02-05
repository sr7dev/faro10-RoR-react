class EntriesPrescription < ApplicationRecord
  belongs_to :entry
  belongs_to :prescription

  validates :day_taken, presence: true
  validates :prescription_id, presence: true
  validates :times_taken, presence: true

  scope :past_weeks, ->(weeks) { joins(:entry).where(entries: {created_at: weeks.weeks.ago..Time.now}) }
end
