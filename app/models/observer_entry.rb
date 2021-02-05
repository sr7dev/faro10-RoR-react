class ObserverEntry < ApplicationRecord
  belongs_to :observation
  has_one :observee, through: :observation, class_name: "Member", foreign_key: :member_id
  has_one :observer, through: :observation, class_name: "Member"
  # validates_presence_of :observation_id, :observed_at

  scope :by_race, ->(race) { joins(:member).where(users: {race: race})}
  scope :by_gender, ->(gender) {joins(:member).where(users: {gender: gender})}
  scope :by_diagnosis, ->(diagnosis) {joins(:member).where(users: {diagnosis: diagnosis})}
  scope :by_prescription, ->(prescription) {joins(:prescriptions).where(users: {prescription: prescription})}
  scope :with_journal_entry, -> { where("observer_entries.journal IS NOT NULL AND observer_entries.journal != ''") }

  before_save :override_value

  def override_value
    if self.feeling == -1
      self.feeling = nil
    end
    if self.energy == -1
      self.energy = nil
    end
    if self.emotion == -1
      self.emotion = nil
    end
    if self.activity == -1
      self.activity = nil
    end
    if self.hyperactive == -1
      self.hyperactive = nil
    end
    if self.hallucination == -1
      self.hallucination = nil
    end
    if self.work_life == -1
      self.work_life = nil
    end
    if self.social_interaction == -1
      self.social_interaction = nil
    end
    if self.family_life == -1
      self.family_life = nil
    end
    if self.delusional == -1
      self.delusional = nil
    end
    if self.dangerous_behavior == -1
      self.dangerous_behavior = nil
    end
    if self.zest == -1
      self.zest = nil
    end
    if self.substance_abuse == -1
      self.substance_abuse = nil
    end
  end

end
