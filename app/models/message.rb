class Message < ApplicationRecord
  belongs_to :clinician
  belongs_to :member

  has_many :meeting_messages

  scope :archived,   -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  def self.unread
    where(read: false)
  end

  def self.read
    where(read: true)
  end

  def archive
    update(archived: true)
  end

  def unarchive
    update(archived: false)
  end
end
