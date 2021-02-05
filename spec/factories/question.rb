FactoryBot.define do
  factory :question do
    text { "1. My mind has never been sharper." }
    position { 1 }
    answerable { true }
    comment { nil }
    style { "multiple_choice" }
    parent_id { nil }
  end
end
