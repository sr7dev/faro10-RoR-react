class Clinician < User

  belongs_to :group, optional: :true
  has_many :memberships
  has_many :members, through: :memberships
  has_many :messages
  #has_many :alerts
  has_many :clinician_entries
  #has_many :diagnoses
  #has_many :medical_conditions, through: :diagnoses
  has_many :subscriptions, dependent: :destroy

  validates :clinic_name, presence: true
  validates :clinic_street, presence: true
  validates :clinic_city, presence: true
  validates :clinic_state, presence: true
  validates :clinic_zip, presence: true
  validates :clinic_phone, phone: true

  before_save :format_phone

  scope :active_membership_at, ->(time) { joins(:members).merge(Member.active_membership_at(time)) }
  scope :near_zip, ->(zip) { select(:clinic_name, :clinic_street, :clinic_city, :clinic_state, :clinic_zip, :latitude, :longitude).near(zip, 50) }
  scope :featured, -> { where.not(featured_at: nil) }

  devise :confirmable, :database_authenticatable, :password_archivable, :password_expirable,
         :recoverable, :registerable, :rememberable, :timeoutable, :trackable

  def active_members
    members.where(memberships: {status: "active"})
  end

  def active_subscription?
    subscriptions.active.any?
  end

  def pending_members
    members.where(memberships: {status: "pending"})
  end

  def feelings_sum
    self.entries.group('date(created_at)').sum(:feeling)
  end

  def feelings_avg
    self.entries.group('date(created_at)').average(:feeling)
  end

  def send_admin_notification
    Admin.all.each do |admin|
      AdminMailer.delay.clinician_registration(admin, self)
    end
  end

  private

  def format_phone
    phone = Phonelib.parse(self.clinic_phone)
    self.clinic_phone = phone.full_e164
  end
end
