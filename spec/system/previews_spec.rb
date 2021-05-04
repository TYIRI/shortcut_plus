require 'rails_helper'

RSpec.describe "Previews", type: :system do
  describe '公開レシピ' do
    let(:user) { create(:user) }
      
    before do
      activate user
      sign_in_as user
    end

    context '他のユーザーの投稿レシピをプレビュー' do
      it 'プレビューが表示されないこと' do
        other_user = create(:user)
        recipe = create(:recipe, :published, user: other_user)
        visit preview_path(recipe.id)
        expect(page).to have_content "ページが見つかりません(404)"
      end
    end

    context '自分の投稿レシピを表示' do
      it 'プレビューリンクが表示されていないこと' do
        recipe = create(:recipe, :published, user: user)
        visit my_recipes_path
        expect(page).to_not have_selector "a[href='#{preview_path(recipe.id)}']"
      end
    end
  end

  describe '下書きレシピ' do
    let(:user) { create(:user) }
      
    before do
      activate user
      sign_in_as user
    end
    
    context '他のユーザーの下書きレシピをプレビュー' do
      it 'プレビューが表示されないこと' do
        other_user = create(:user)
        recipe = create(:recipe, :draft, user: other_user)
        visit preview_path(recipe.id)
        expect(page).to have_content "ページが見つかりません(404)"
      end
    end

    context '自分の下書きレシピをプレビュー' do
      it 'プレビューが表示されること' do
        recipe = create(:recipe, :draft, user: user)
        visit my_recipes_path
        find("a[href='#item2']").click
        find("a[href='#{preview_path(recipe.id)}']").click
        windows = page.driver.browser.window_handles
        page.driver.browser.switch_to.window(windows.last)
        expect(current_path).to eq preview_path(recipe.id)
        expect(page).to have_content recipe.title
      end
    end
  end
end
