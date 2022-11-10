FactoryBot.define do
  factory :user do
    first_name { Faker::Name.male_first_name }
  end
end
