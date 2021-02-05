class PrescriptionSerializer < ActiveModel::Serializer
  attributes :id, :reminder, :dosage, :started, :ended,
    :total_times_taken, :duration, :consistency, :reason, :as_needed

  has_one :drug

  delegate :total_times_taken,
    :duration,
    :consistency, 
    to: :object

  def reminder
    object.display_reminder
  end
end
