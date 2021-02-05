FactoryBot.define do
  factory :exercise do
    longname { "Bipolar Mania Test" }
    shortname { "bmt" }
    logo { "bipolar_mania_test_icon.png" }
    description { "This bipolar disorder mania screening test can help determine whether you might have the symptoms of mania. This mania quiz can be used on a weekly basis to track your moods. Changes of five or more points are significant." }
    sub_description { "The items below refer to how you have felt during the past week. For each item, indicate the extent to which it is true, by selecting the appropriate option next to the item." }
    category { "bipolar" }
  end
end
