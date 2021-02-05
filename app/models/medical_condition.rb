class MedicalCondition < ApplicationRecord
  has_many :diagnoses
  has_many :members, through: :diagnoses
  has_many :clinicians, through: :diagnoses

  scope :dsm5_diagnosis, -> { where(is_dsm: true, is_not_header: true) }
  scope :icd10_diagnosis, -> { where(is_dsm: false, is_not_header: true) }

  scope :search_dsm5, -> (description) {
    self.dsm5_diagnosis
    .where(
      "short_description ILIKE ? OR dsm_code ILIKE ?",
      "%#{description}%",
      "%#{description}%",
    )
  }

  scope :search_icd10, -> (description) {
    self.icd10_diagnosis
    .where(
      "short_description ILIKE ? OR icd10_code ILIKE ?",
      "%#{description}%",
      "%#{description}%",
    )
  }

  def dsm5_code_with_description
    "#{dsm_code} : #{short_description}"
  end

  def icd10_code_with_description
    "#{icd10_code} : #{short_description}"
  end

  def self.header_row
    where(is_not_header: false)
  end
end
