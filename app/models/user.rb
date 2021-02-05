class User < ApplicationRecord

  self.inheritance_column = :type

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  AGE_GROUPS = [
                [0,12],
                [13,17],
                [18,24],
                [25,34],
                [35,44],
                [45,64],
                [65,200]
               ]

  has_many :entries
  has_many :facebook_posts


  accepts_nested_attributes_for :entries

  validates :user_id, presence: true
  validates :user_id, length: { maximum: 50 }
  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: { case_sensitive: false }
  # validates :emergency_contact_num, format: /\d{3}-\d{3}-\d{4}/, allow_nil: true
  # validates :race, inclusion: { in: ["Caucasian", "African American", "Asian", "Hispanic"], message: "must be Caucasian, African American, Asian, or Hispanic." }
  # validates :gender, inclusion: { in: %w(Male Female), message: "must be Male or Female." }
  after_validation :geocode
  before_save :downcase_email

  geocoded_by :address

  devise :confirmable, :database_authenticatable, :invitable, :password_archivable, :lockable,
         :recoverable, :registerable, :rememberable, :secure_validatable, :timeoutable, :trackable

  scope :members,  -> { where(type: 'Members') }
  scope :clinicians,  -> { where(type: 'Clinicians') }

  # TODO: Refactor all references to user_id
  def full_name
    user_id
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def address
    [clinic_street, clinic_city, clinic_state].compact.join(', ')
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.all_diagnosis
    User.group('diagnosis').select('diagnosis').map(&:diagnosis).compact
  end

  def self.age_groups
    AGE_GROUPS.map do |age_range|
      {name: "#{age_range[0]} - #{age_range[1]}",
       y: User.age_group(age_range).count}
    end
  end

  def self.age_group(age_range)
    now = Date.today
    start_date = now - (age_range[1] + 1).years + 1.day
    end_date = now - age_range[0].years
    where(dob: start_date..end_date)
    # select(:dob).group(:dob).having("dob >= #{start_date} AND dob <= #{end_date}")
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def get_token
    token = self.api_key

    if token.nil? || self.api_token_expired?
      return self.set_token
    else  
      return token
    end
  end

  def set_token
    token = User.new_token
    update_attributes(api_key: token, api_key_expiry: Time.now + 30.days)
    return token
  end

  def check_token(token)
    (self.api_key == token) && !api_token_expired?
  end

  def api_token_expired?
    self.api_key_expiry.present? ? self.api_key_expiry <= Time.now : true
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def add_facebook_authorization(auth)
    update_attributes(:uid => auth.uid, :oauth_token => auth.credentials.token, :oauth_expires_at => Time.at(auth.credentials.expires_at))
  end

  def feelings_sum
    self.entries.group('date(created_at)').sum(:feeling)
  end

  def feelings_avg
    self.entries.group('date(created_at)').average(:feeling)
  end

  def energies_sum
    self.entries.group('date(created_at)').sum(:energy)
  end

  def energies_avg
    self.entries.group('date(created_at)').average(:energy)
  end

  def send_clinician_invitation(email)
    UserMailer.delay.invite_clinician(email)
  end

  def send_observer_invitation(email)
    UserMailer.delay.invite_observer(email)
  end

  def send_member_invitation(email)
    UserMailer.delay.invite_member(email)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def age
    if dob.present?
      ((Date.today - dob).to_i/365)
    else
      'None Provided'
    end
  end

  def send_password_change_notification?
    super && !accepting_invitation?
  end

  def self.primary_role
    User.primary_role
  end

  def twilio_token
    tempVar = user_id + "<span style='display:none'>" + email + "</span>"
    token = Twilio::JWT::AccessToken.new(
      ENV.fetch("TWILIO_ACCOUNT_SID"),
      ENV.fetch("TWILIO_API_KEY"),
      ENV.fetch("TWILIO_API_SECRET"),
      [],
      identity: id,
      valid_until: (Time.now + 1.days).to_i
    )

    # Grant access to Video
    grant = Twilio::JWT::AccessToken::VideoGrant.new

    # Room name
    # grant.room = "#{email}'s Room"
    token.add_grant grant

    token
  end

  def twilio_token_json
    token = twilio_token

    {
      identity: email,
      token: token.to_jwt
    }.to_json
  end

  private
    def downcase_email
      self.email = email.downcase
    end
end
