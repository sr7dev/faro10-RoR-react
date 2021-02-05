class Entry < ApplicationRecord
  belongs_to :member, counter_cache: true

  has_many :entries_prescriptions
  has_many :entries_symptoms, inverse_of: :entry, dependent: :destroy
  has_many :symptoms, through: :entries_symptoms

  validates :member_id, presence: true

  accepts_nested_attributes_for :entries_prescriptions
  accepts_nested_attributes_for :entries_symptoms, reject_if: :all_blank

  # METHODS FOR CHARTS
  #  scope :by_race, ->(race) { joins(:user).where(users: {race: race})}
  #  scope :by_gender, ->(gender) {joins(:user).where(users: {gender: gender})}

  scope :within_membership, ->(membership) {where('created_at < ? AND member_id = ?', membership.valid_until, membership.member_id)}

  scope :by_race, ->(race) {joins(:member).where(users: {race: race})}
  scope :by_gender, ->(gender) {joins(:member).where(users: {gender: gender})}
  scope :by_diagnosis, ->(diagnosis) {joins(:member).where(users: {diagnosis: diagnosis})}
  scope :by_prescription, ->(prescription) {joins(:prescriptions).where(users: {prescription: prescription})}

  scope :sum_feelings, -> {group('date(Entries.created_at)').sum(:feeling).map {|k, v| [k, v]}}
  scope :avg_feelings, -> {group('date(Entries.created_at)').average(:feeling).map {|k, v| [k, v]}}

  scope :sum_energies, -> {group('date(Entries.created_at)').sum(:energy).map {|k, v| [k, v]}}
  scope :avg_energies, -> {group('date(Entries.created_at)').average(:energy).map {|k, v| [k, v]}}

  scope :with_journals, -> {where.not(journal: [nil, ''])}


  # This line works properly.  Uncomment to re-enable Clinician notifications by email
  # after_commit :send_clinician_notification, on: :create

  before_save :override_value

  # END OF CHART METHODS

  def created_at_ts
    created_at.to_date.to_time.to_i
  end

  def self.all_feelings_sum
    group('date(created_at)').sum(:feeling)
  end

  def self.all_feelings_avg
    group('date(created_at)').average(:feeling)
  end

  def self.all_energies_sum
    group('date(created_at)').sum(:energy)
  end

  def self.all_energies_avg
    group('date(created_at)').average(:energy)
  end


  def self.feeling_total_on(date)
    where("date(created_at) = ?", date).sum(:feeling)
  end

  def self.feeling_average_on(date)
    where("date(created_at) = ?", date).average(:feeling)
  end

  def self.energy_average_on(date)
    where("date(created_at) = ?", date).average(:energy)
  end

  def danger_words
    ['kill', 'Kill', 'suicide', 'gun', 'Gun', 'die']
  end

  def journal_danger?
    if journal.nil?
      false
    else
      danger_words.any? {|word| journal.include?(word)}
    end
  end

  def danger_entries
    [
        {feeling: 6, anxiety: 6, zest: 6},
        {social_life: 10, family_life: 10, work_life: 10},
    ]
  end

  def entry_danger?
    danger_entries.each do |condition|
      passed = true
      condition.each do |k, v|
        passed = false unless send(k) == v
        break unless passed
      end
      return true if passed
    end
    false
  end

  def any_danger?
    journal_danger? || entry_danger? == true
  end

  def alert_type_method
    if journal_danger? == true
      "Journal Alert"
    elsif entry_danger? == true
      "Entry Alert"
    else
      "no alert"
    end
  end

  def alert_body_method
    if journal_danger? == true
      journal
    elsif entry_danger? == true
      "Faro10 has identified entries of concern based on behavioral entries"
    else
      "no alert"
    end
  end

  private

  def send_clinician_notification
    entry = self

    unless entry.any_danger?
      patient = entry.member
      clinicians = patient.memberships.active.map(&:clinician)

      for clinician in clinicians
        UserMailer.delay.patient_entry_notification(entry, patient, clinician)
      end
    end
  end

  def override_value
    if self.feeling == -1
      self.feeling = nil
    end
    if self.energy == -1
      self.energy = nil
    end
    if self.anxiety == -1
      self.anxiety = nil
    end
    if self.pessimism == -1
      self.pessimism = nil
    end
    if self.initiative == -1
      self.initiative = nil
    end
    if self.concentration == -1
      self.concentration = nil
    end
    if self.work_life == -1
      self.work_life = nil
    end
    if self.social_life == -1
      self.social_life = nil
    end
    if self.family_life == -1
      self.family_life = nil
    end
    if self.self_harm == ""
      self.self_harm = nil
    end
    if self.sleep == -1
      self.sleep = nil
    end
    if self.zest == -1
      self.zest = nil
    end
    if self.appetite == -1
      self.appetite = nil
    end
  end
end
