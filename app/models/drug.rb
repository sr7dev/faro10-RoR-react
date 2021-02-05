class Drug < ApplicationRecord
  has_many :prescriptions
  has_many :members, through: :prescriptions

  def self.all_names
    pluck(:friendly_name).uniq
  end
end
