class SymptomSerializer < ActiveModel::Serializer
  attributes :id, :name, :patient_id
end
