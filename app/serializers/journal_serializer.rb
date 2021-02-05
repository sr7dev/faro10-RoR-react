class JournalSerializer < ActiveModel::Serializer
  attributes :entry_id, :date, :text

  def entry_id
    object.id
  end

  def date
    object.created_at.strftime("%Y-%m-%d")
    # object.created_at.in_time_zone(object.member.time_zone).strftime("%Y-%m-%d")
  end

  def text
    object.journal
  end
end
