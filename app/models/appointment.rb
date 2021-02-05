class Appointment < ApplicationRecord
  belongs_to :member

  validates :created_by, presence: true
  validates :duration, presence: true
  validates :start_time, presence: true
  validates :title, presence: true

  before_save :set_end_time

  private

  def set_end_time
    self.end_time = start_time + duration.minutes
  end

end
