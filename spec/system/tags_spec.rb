require 'rails_helper'

RSpec.describe "Tags", type: :system do
  describe 'タグ画面' do
    it '選択タグのレシピが表示されること' do
      recipe = create(:recipe, :published)
      tag_map = create(:tag_map, recipe: recipe)
      visit root_path
      page.first("a[class='text-dark tag'][href='#{tag_path(tag_map.tag_id)}']").click
      expect(current_path).to eq tag_path(tag_map.tag_id)
      expect(page).to have_content recipe.title
    end
    
    it '選択タグ外のレシピが表示されないこと' do
      recipe = create(:recipe, :published)
      create(:tag_map, recipe: recipe)
      tag = create(:tag)
      visit tag_path(tag)
      expect(page).to_not have_content recipe.title      
    end
  end
end
