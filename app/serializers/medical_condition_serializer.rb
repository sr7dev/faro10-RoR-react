class MedicalConditionSerializer < ActiveModel::Serializer
  attributes :id, :long_description, :short_description, :icd10_code, :dsm_code
end
