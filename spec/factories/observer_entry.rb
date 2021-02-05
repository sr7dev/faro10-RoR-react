FactoryBot.define do
  factory :observer_entry do
    feeling { 4 }
    emotion { 3 }
    journal { "this is a journal entry" }
    observed_at { DateTime.new(2017, 6, 1) }
  end
end
