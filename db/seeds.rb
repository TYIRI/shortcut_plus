require 'factory_bot'

# カテゴリを作成（5つ）
5.times do
  FactoryBot.create(:category)
end

# レシピを作成（40記事）
40.times do
  user = FactoryBot.create(:user)
  FactoryBot.create(:recipe, :published, user: user, category_id: rand(5) + 1)
end
