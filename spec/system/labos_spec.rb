require 'rails_helper'

RSpec.describe "Labos", type: :system do
  describe 'ユーザー画面' do
    it '選択ユーザーのレシピが表示されること' do
      recipe = create(:recipe, :published)
      visit root_path
      page.first("a[class='text-dark d-flex align-items-center word-break-all'][href='#{labo_path(recipe.user)}']").click
      expect(current_path).to eq labo_path(recipe.user)
      expect(page).to have_content recipe.title
    end

    it '選択ユーザー以外のレシピが表示されないこと' do
      recipe = create(:recipe, :published)
      other_recipe = create(:recipe, :published)
      visit labo_path(other_recipe.user)
      expect(page).to_not have_content recipe.title      
    end
  end
end
