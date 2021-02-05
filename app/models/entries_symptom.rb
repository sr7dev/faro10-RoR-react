class EntriesSymptom < ApplicationRecord
  belongs_to :entry
  belongs_to :symptom, inverse_of: :entries_symptoms

  accepts_nested_attributes_for :symptom, reject_if: :reject_symptom

  validates :entry, presence: true 
  validates :symptom, presence: true

  private

  def reject_symptom(attributes)
    attributes['name'].blank?
  end
end
