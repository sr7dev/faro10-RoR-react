FactoryBot.define do
  factory :meeting_user do
    user { nil }
    meeting { nil }
    anonymous { false }
    comfortable_leading { false }
    mood_rating { 1 }
  end
end
