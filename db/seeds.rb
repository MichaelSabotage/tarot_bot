# Create areas
Area.create(name: "Таро", description: Faker::Lorem.paragraph(sentence_count: 10))
Area.create(name: "Нумерология", description: Faker::Lorem.paragraph(sentence_count: 7))
Area.create(name: "Психология", description: Faker::Lorem.paragraph(sentence_count: 13))

# Create topics
Area.all.each do |area|
  3.times do
    Topic.create(name: Faker::Hobby.activity, description: Faker::Lorem.paragraph(sentence_count: rand(10..18)),
                 area_id: area.id)
  end
end

# Create readings
Topic.all.each do |topic|
  3.times do
    Reading.create(name: Faker::Hobby.activity,
                   description: Faker::Lorem.paragraph(sentence_count: rand(10..18)),
                   topic_id: topic.id,
                   basic_price: [1000, 1200, 1500, 2000, 2500, 3000].sample,
                   processing_time: [30, 60, 90, 120].sample)
  end
end
