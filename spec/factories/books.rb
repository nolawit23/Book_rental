FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    isbn {  "1234567890123" }
    available_copies { rand(0..5) } 
  end
end
