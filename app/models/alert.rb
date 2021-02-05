class Alert < ApplicationRecord
  belongs_to :member
  belongs_to :clinician, optional: true
  has_many :entries

  scope :visible_to, ->(membership) { where(member: membership.member).where("created_at < ?", membership.valid_until) }
  scope :with_alert, -> { where(alert: true) }

  after_commit :send_sms_alert, on: :create
  after_commit :send_email_alert, on: :create

  def last_entry
    Member.entries.present? ? Member.entries('created_at').last : "no entries"
  end

  def total_alerts
    Alerts.count
  end

  def send_text_alert
    case
      when journal_alert?
        "An item of concern has been identified in a journal."
      when entry_alert?
        "Faro10 has identified entries of concern and recommends reaching out to #{user} and remind them that people care."
      else
        false
    end
  end

  def send_sms_alert
    memberships = member.memberships.active.journal_visible?

    phone_numbers = []

    memberships.each do |membership|
      if membership.clinician.allow_sms_notifications
        phone_numbers << membership.clinician.clinic_phone
      end
    end

    phone_numbers.compact!

    phone_numbers.each do |phone|
      ClinicianTexter.new_alert(phone).deliver_later
    end
  end

  def send_email_alert
    memberships = member.memberships.active.journal_visible?

    memberships.each do |membership|
      UserMailer.patient_alert_notification(member, membership.clinician).deliver_later
    end
  end
end
