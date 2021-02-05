class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :created_by, :start_time, :title
end
