FactoryBot.define do
  factory :drug do
    trait :advil do
      scientific_name { "Ibuprofin" }
      friendly_name { "Advil" }
      pharma_comp { "Phizer" }
    end

    trait :abilify do
      scientific_name { "Aripiprazole" }
      friendly_name { "Abilify" }
      pharma_comp { "Bristol-Meyers Squibb" }
    end
  end
end
