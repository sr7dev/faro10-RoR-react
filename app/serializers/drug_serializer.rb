class DrugSerializer < ActiveModel::Serializer
  attributes :scientific_name, :friendly_name, :pharma_comp, :id

end