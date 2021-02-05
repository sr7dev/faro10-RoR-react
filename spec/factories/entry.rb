FactoryBot.define do
  factory :entry do
    feeling { 5 }
    emotion { 5 }
    energy { 2 }
    anxiety { 2 }
    headache { 8 }
    created_at { Date.new(2017, 10, 1) }
  end
end
