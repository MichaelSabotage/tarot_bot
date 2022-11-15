FactoryBot.define do
  factory :reading do
    name { "MyString" }
    description { "MyText" }
    association :topic
  end
end
