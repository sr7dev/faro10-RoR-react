FactoryBot.define  do
  factory :observation do
    relationship { "Mother" }
    status { "active" }
    guardian { true }
  end
end
