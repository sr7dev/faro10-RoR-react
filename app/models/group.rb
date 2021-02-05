class Group < ApplicationRecord
  has_many :clinicians
  validates :name, uniqueness: true

  def feelings_sum
    self.entries.group('date(created_at)').sum(:feeling)
  end

  def feelings_avg
    self.entries.group('date(created_at)').average(:feeling)
  end
end
