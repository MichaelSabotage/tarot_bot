FactoryBot.define do
  factory :topic do
    name { "MyString" }
    description { "MyText" }
    association :area
  end
end
