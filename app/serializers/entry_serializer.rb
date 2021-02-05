class EntrySerializer < ActiveModel::Serializer
  attributes :feeling, :emotion, :energy, :activity, :anxiety, :headache,
             :created_at, :updated_at, :hrs_slept, :took_meds, :suicide_thought, :zest, :pessimism, :initiative, :concentration,
             :appetite, :reported_mood, :restlessness, :dry_mouth, :nausea, :nightmare, :weight

  has_one :member, serializer: UserSerializer
  has_many :symptoms

end