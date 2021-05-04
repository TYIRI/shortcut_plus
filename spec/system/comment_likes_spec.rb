require 'rails_helper'

RSpec.describe "CommentLikes", type: :system do
  describe 'ログイン前' do
    it 'いいねボタンが押下できないこと' do
      recipe = create(:recipe, :published)
      comment = create(:comment, recipe: recipe)
      visit recipe_path(recipe)
      expect(page).to_not have_selector "a[data-method='post'][id='js-like-button-for-comment-#{comment.id}']"
      within('.comment-area') do
        expect(page).to have_css '.guest-like-btn'
      end
    end
  end

  describe 'ログイン後' do
    let(:user) { create(:user) }
    
    before do
      activate user
      sign_in_as user
    end

    context 'コメントをいいねしていない状態' do
      it 'コメントにいいねできること' do
        recipe = create(:recipe, :published)
        comment = create(:comment, recipe: recipe)
        visit recipe_path(recipe)
        expect {
          find("a[data-method='post'][id='js-like-button-for-comment-#{comment.id}']").click
          expect(current_path).to eq recipe_path(recipe)
          expect(page).to_not have_selector "a[data-method='post'][id='js-like-button-for-comment-#{comment.id}']"
          expect(page).to have_selector "a[href='#{comment_like_path(comment.id)}']"
        }.to change(CommentLike, :count).by(1)
      end
    end

    context 'コメントをいいねしている状態' do
      it 'コメントのいいねが解除できること' do
        recipe = create(:recipe, :published)
        comment = create(:comment, recipe: recipe)
        create(:comment_like, comment: comment, user: user)
        visit recipe_path(recipe)
        expect {
          find("a[href='#{comment_like_path(comment.id)}']").click
          expect(current_path).to eq recipe_path(recipe)
          expect(page).to_not have_selector "a[href='#{comment_like_path(comment.id)}']"
          expect(page).to have_selector "a[data-method='post'][id='js-like-button-for-comment-#{comment.id}']"
        }.to change(CommentLike, :count).by(-1)
      end
    end
  end
end
