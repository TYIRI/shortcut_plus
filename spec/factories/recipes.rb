FactoryBot.define do
  factory :recipe do
    title { "MyString" }
    content { "MyText" }
    status { 1 }
    shortcut_id { "MyString" }
    published_at { "2021-03-14 17:23:13" }
  end
end
