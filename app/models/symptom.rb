class Symptom < ApplicationRecord
  has_many :entries, through: :entries_symptoms
  has_many :entries_symptoms, dependent: :destroy
  has_many :members, through: :entries
  has_many :tracked_symptoms, dependent: :destroy
  has_many :tracked_by, through: :tracked_symptoms, source: :member

  scope :default, -> { where(patient_id: nil) }
  scope :created_by_patient, -> (patient_id) { where('patient_id = ?', patient_id) }
  scope :available_to_patient, -> (patient_id) { default + created_by_patient(patient_id) }
end
