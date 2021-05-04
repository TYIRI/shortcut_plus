require 'rails_helper'

RSpec.describe "Categories", type: :system do
  describe 'カテゴリ画面' do
    it '選択カテゴリのレシピが表示されること' do
      recipe = create(:recipe, :published)
      visit root_path
      find("a[class='text-dark category-list'][href='#{category_path(recipe.category)}']").click
      expect(current_path).to eq category_path(recipe.category)
      expect(page).to have_content recipe.title
    end
    
    it '選択カテゴリ外のレシピが表示されないこと' do
      recipe = create(:recipe, :published)
      other_category = create(:category)
      visit category_path(other_category)
      expect(page).to_not have_content recipe.title      
    end
  end
end
