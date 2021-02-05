class Diagnosis < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :clinician, optional: true
  belongs_to :medical_condition, optional: true

  scope :dsm5_diagnosis, -> { joins(:medical_condition).merge(MedicalCondition.dsm5_diagnosis) }
  scope :icd10_diagnosis, -> { joins(:medical_condition).merge(MedicalCondition.icd10_diagnosis) }
end
