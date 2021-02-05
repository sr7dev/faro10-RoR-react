class Observation < ApplicationRecord
  belongs_to :observee, class_name: "Member", foreign_key: :member_id
  belongs_to :observer, class_name: "Member"
  has_many :observer_entries, foreign_key: :observation_id
  has_many :observer_entries_on_me, foreign_key: :observation_id, class_name: "ObserverEntry"


  scope :active,       -> { where(status: "active") }
  scope :inactive,     -> { where(status: "inactive") }
  scope :meds_visible, -> { where(guardian: true) }

  def meds
    guardian ? 1 : 0
  end

  def meds=(attr)
    case attr
    when "1"
      self.update(guardian: true)
    when "0"
      self.update(guardian: false)
    else
      self.update(guardian: false)
    end
  end

  def meds_visible
    where(guardian: true)
  end

  def last_entry
    observee.entries.present? ? observee.entries('created_at').last.created_at.to_date.strftime("%A, %B %d, %Y") : "no entries"
  end

  def total_entries
    observee.entries.present? ? observee.entries.distinct.count(:created_at) : 0
  end


end
