require 'rails_helper'

RSpec.describe "RecipeLikes", type: :system do
  describe 'ログイン前' do
    let(:recipe) { create(:recipe, :published) }

    it 'いいねボタンが押下できないこと' do
      visit recipe_path(recipe)
      expect(page).to_not have_selector "a[data-method='post'][id='js-like-button-for-recipe-#{recipe.id}']"
      expect(page).to have_css '.guest-like-btn'
    end
  end

  describe 'ログイン後' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, :published) }
    
    before do
      activate user
      sign_in_as user
    end

    context 'レシピをいいねしていない状態' do
      it 'レシピにいいねできること' do
        visit recipe_path(recipe)
        expect {
          find("a[data-method='post'][id='js-like-button-for-recipe-#{recipe.id}']").click
          expect(current_path).to eq recipe_path(recipe)
          expect(page).to_not have_selector "a[data-method='post'][id='js-like-button-for-recipe-#{recipe.id}']"
          expect(page).to have_selector "a[href='#{recipe_like_path(recipe.id)}']"
        }.to change(RecipeLike, :count).by(1)
      end
    end

    context 'レシピをいいねしている状態' do
      it 'レシピのいいねが解除できること' do
        create(:recipe_like, recipe: recipe, user: user)
        visit recipe_path(recipe)
        expect {
          find("a[href='#{recipe_like_path(recipe.id)}']").click
          expect(current_path).to eq recipe_path(recipe)
          expect(page).to_not have_selector "a[href='#{recipe_like_path(recipe.id)}']"
          expect(page).to have_selector "a[data-method='post'][id='js-like-button-for-recipe-#{recipe.id}']"
        }.to change(RecipeLike, :count).by(-1)
      end
    end
  end
end
