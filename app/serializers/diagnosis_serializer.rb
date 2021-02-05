class DiagnosisSerializer < ActiveModel::Serializer
  attributes :id, :member_id, :icd10_code
end
