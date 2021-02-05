class Member < User
  has_many :alerts
  has_many :appointments
  has_many :clinicians, through: :memberships
  has_many :clinician_entries
  has_many :channels
  has_many :drugs, through: :prescriptions
  has_many :dsm_diagnoses, -> { Diagnosis.dsm5_diagnosis }, class_name: "Diagnosis"
  has_many :icd_diagnoses, -> { Diagnosis.icd10_diagnosis }, class_name: "Diagnosis"
  has_many :entries
  has_many :entries_prescriptions, through: :entries
  has_many :entries_symptoms, through: :entries
  has_many :memberships
  has_many :meeting_users
  has_many :meetings
  # has_many :meetings, through: :meeting_users
  has_many :messages
  has_many :observations_on_me, class_name: "Observation", foreign_key: :member_id
  has_many :observers, through: :observations_on_me
  has_many :observations_of_others, class_name: "Observation", foreign_key: :observer_id
  has_many :observees, through: :observations_of_others
  has_many :observer_entries, through: :observations_of_others
  has_many :observer_entries_on_me, through: :observations_on_me
  has_many :prescriptions
  has_many :symptoms, -> { distinct }, through: :entries
  has_many :tracked_symptoms, class_name: "TrackedSymptom", foreign_key: :patient_id
  has_many :tracked_symptom_symptoms, class_name: "Symptom", through: :tracked_symptoms, source: :symptom
  has_many :active_observations_on_me, -> { where(status: "Active") }, class_name: "Observation", foreign_key: :member_id
  has_many :active_observers, through: :active_observations_on_me, foreign_key: :observer_id
  has_many :observee_prescriptions, through: :observees

  scope :active_at, ->(time) { joins(:memberships).merge(Membership.active_at(time)).uniq }
  scope :active_during, ->(daterange) { joins(:memberships).merge(Membership.active_during(daterange)).uniq }
  scope :by_race, ->(race) { where(users: {race: race})}
  scope :by_gender, ->(gender) { where(users: {gender: gender})}
  scope :by_diagnosis, ->(diagnosis) { where(users: {diagnosis: diagnosis})}
  scope :by_country, ->(country) { where(users: {country: country})}
  scope :by_prescription, ->(drug_name) { joins(prescriptions: :drug).where(drugs: {friendly_name: drug_name}).uniq }
  scope :with_entries_prescriptions, -> { joins(:entries_prescriptions).distinct }
  scope :with_observer_journal_entries, -> { joins(:observer_entries_on_me).merge(ObserverEntry.with_journal_entry) }
  scope :with_appointments, -> { joins(:appointments) }

  # validates :gender, inclusion: { in: %w(Male Female), message: "must be Male or Female." }

  def self.active_membership_count_grouped_by_date
    # returns data for the clinician dashboard patient count modal
    joins(:memberships).merge(Membership.active).group('date(memberships.updated_at)').count.map{|k,v| [k.to_date.to_time.to_i*1000, v]}
  end

  def observer_journal_entries
     observer_entries_on_me.where.not(journal: [nil, '']).order(observed_at: :desc)
  end

  def connected_to_facebook?
    !!oauth_token
  end

  def avg_med_consistency
    prescriptions.present? ? prescriptions.unexpired.map(&:consistency).sum.to_f / prescriptions.unexpired.count.round : 0
  end

  def drugs_by_name_and_dosage
    self.prescriptions.joins(:drug).pluck(:friendly_name, :dosage)
  end

  def feelings_sum
    self.entries.group('date(created_at)').sum(:feeling)
  end

  def feelings_avg
    self.entries.group('date(created_at)').average(:feeling)
  end

  def recent_entries
    entries.where("created_at >= ?", (Date.today - 2.weeks))
  end

  def to_s
    user_id
  end

  def self.percent_diagnosed_with(diagnosis = nil)
    if diagnosis
      diagnosed = Member.where(diagnosis: diagnosis).count
    else
      diagnosed = Member.where(diagnosis: ['', nil, "Unknown"]).count
    end
    total = Member.all.count

    (diagnosed.to_f / total * 100)
  end

  def self.percent_medicated_with(drug)
    if drug
      drug = Drug.find_by_friendly_name(drug)
      medicated = Member.joins(:prescriptions).where(prescriptions: {drug_id: drug.id}).uniq.count
    end
    total = Member.all.count

    (medicated.to_f / total * 100)
  end
end
