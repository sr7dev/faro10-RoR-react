class ClinicianEntry < ApplicationRecord
  belongs_to :member
  belongs_to :clinician
end
