class Meeting < ApplicationRecord
  has_many :meeting_messages
  has_many :meeting_users
  # has_many :messages, through: :meeting_messages
  has_many :users, through: :meeting_users
  has_one :channel

  validates :password, presence: true, if: :private?
  before_save :set_end_time

  scope :inprogress, -> { where("end_time > ?", Time.current).where("start_time < ?", 15.minutes.from_now).where("status != ?", "complete") }
  scope :complete, -> { where("end_time < ?", Time.current) }
  # TODO maybe we want to share with other that there are people "Wating" in the meeting
  # for the meeting to start
  scope :waiting, -> { where(status: 'waiting') }
  scope :scheduled, -> { where("start_time > ?", Time.current).where("status != ?", "complete") }


  attr_accessor :date, :time

  def private?
    privacy == true
  end

  def complete?
    status == 'complete'
  end

  def complete!
    update(status: 'complete', completed: Date.today)
  end

  def inprogress?
    status == 'in-progress'
  end

  def waiting?
    status == 'waiting'
  end

  def scheduled?
    status == 'scheduled'
  end

  def room_name
    super || "no room name"
  end

  def retrieve_twilio_participants
    api_key_sid = ENV.fetch("TWILIO_ACCOUNT_SID")
    api_key_secret = ENV.fetch("TWILIO_AUTH_TOKEN")
  
    client = Twilio::REST::Client.new api_key_sid, api_key_secret
  
    participants = client.video.rooms(room_name)
                        .participants.list(status: 'connected').each do |participant|
      puts participant.sid
    end
  end

  private

  def set_end_time
    self.end_time = start_time + duration_in_minutes
  end

  def duration_in_minutes
    duration ? duration.minutes : 0
  end

end
