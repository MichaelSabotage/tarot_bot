FactoryBot.define do
  factory :order do
    association :user
    association :reading
    comment { "MyText" }
    answer { "MyText" }
    price { 1500 }
    date { Time.zone.today }
    status { "Выполнен" }
  end
end
