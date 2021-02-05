class TrackedSymptom < ApplicationRecord
  belongs_to :member, class_name: 'Member', foreign_key: :patient_id
  belongs_to :symptom

  validates :member, presence: true 
  validates :symptom, presence: true
  validates :symptom, uniqueness: { scope: :patient_id }
end
