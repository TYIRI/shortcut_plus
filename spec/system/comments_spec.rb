require 'rails_helper'

RSpec.describe "Comments", type: :system do
  describe 'ログイン前' do
    let(:recipe) { create(:recipe, :published) }

    describe 'コメント新規作成' do
      it 'コメント作成エリアが表示されていないこと' do
        visit recipe_path(recipe)
        expect(page).to_not have_selector '#comment-form'
      end
    end

    describe 'コメント編集' do
      it 'コメント編集ボタンが表示されていないこと' do
        recipe = create(:recipe, :published)
        create(:comment, recipe: recipe)
        visit recipe_path(recipe)
        expect(page).to_not have_selector '.js-edit-comment-button'
      end
    end

    describe 'コメント削除' do
      it 'コメント削除ボタンが表示されていないこと' do
        recipe = create(:recipe, :published)
        comment = create(:comment, recipe: recipe)
        visit recipe_path(recipe)
        expect(page).to_not have_selector "a[data-method='delete'][href='#{comment_path(comment)}']"
      end
    end
  end

  describe 'ログイン後' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, :published) }
    
    before do
      activate user
      sign_in_as user
    end

    describe 'コメント新規作成' do
      context 'フォームの入力値が正常' do
        it 'コメントの作成に成功すること' do
          visit recipe_path(recipe)
          find(:css, 'trix-editor').set("コメント本文")
          page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
            page.find('.trix-button--icon-attach').click          
          end
          expect {
            click_button 'コメント投稿'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content 'コメント本文'
          }.to change(Comment, :count).by(1)
        end
      end

      context 'フォームが未入力' do
        it 'コメントの作成に失敗すること' do
          visit recipe_path(recipe)
          find(:css, 'trix-editor').set("")
          expect {
            click_button 'コメント投稿'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content 'コメントを入力してください'
          }.to_not change(Comment, :count)
        end
      end
    end

    describe 'コメント編集' do
      context '他のユーザーが投稿コメントを表示' do
        it 'コメント編集ボタンが表示されていないこと' do
          recipe = create(:recipe, :published)
          other_user = create(:user)
          comment = create(:comment, recipe: recipe, user: other_user)
          visit recipe_path(recipe)
          expect(page).to_not have_selector '.js-edit-comment-button'
        end
      end

      context 'フォームの入力値が正常' do
        it 'コメントの更新に成功すること' do
          recipe = create(:recipe, :published)
          comment = create(:comment, recipe: recipe, user: user)
          visit recipe_path(recipe)
          find('.js-edit-comment-button').click
          within('.edit-comment-form') do
            find(:css, 'trix-editor').set("コメント更新本文")
            page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
              page.find('.trix-button--icon-attach').click          
            end
          end
          expect {
            click_button '更新'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content 'コメント更新本文'
          }.to_not change(Comment, :count)
        end
      end

      context 'フォームが未入力' do
        it 'コメントの更新に失敗すること' do
          recipe = create(:recipe, :published)
          comment = create(:comment, recipe: recipe, user: user)
          visit recipe_path(recipe)
          find('.js-edit-comment-button').click
          within('.edit-comment-form') do
            find(:css, 'trix-editor').native.clear
          end
          expect {
            click_button '更新'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content 'コメントを入力してください'
          }.to_not change(Comment, :count)
        end
      end

      context 'コメントの編集をキャンセルする' do
        it 'コメントの更新キャンセルに成功すること' do
          recipe = create(:recipe, :published)
          comment = create(:comment, recipe: recipe, user: user)
          visit recipe_path(recipe)
          find('.js-edit-comment-button').click
          within('.edit-comment-form') do
            find(:css, 'trix-editor').set("コメント更新本文")
          end
          expect {
            click_button 'キャンセル'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to_not have_content 'コメント更新本文'
            expect(page).to have_content 'コメントの内容です。'
          }.to_not change(Comment, :count)
        end
      end
    end

    describe 'コメント削除' do
      context '他のユーザーの投稿コメントを表示' do
        it 'コメント削除ボタンが表示されていないこと' do
          recipe = create(:recipe, :published)
          other_user = create(:user)
          comment = create(:comment, recipe: recipe, user: other_user)
          visit recipe_path(recipe)
          expect(page).to_not have_selector "a[data-method='delete'][href='#{comment_path(comment)}']"
        end
      end

      context '自分の投稿コメントを削除' do
        it 'コメントの削除に成功すること' do
          recipe = create(:recipe, :published)
          comment = create(:comment, recipe: recipe, user: user)
          visit recipe_path(recipe)
          expect {
            page.accept_confirm do
              find("a[data-method='delete'][href='#{comment_path(comment)}']").click
            end
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to_not have_content 'コメントの内容です。'
          }.to change(Comment, :count).by(-1)
        end
      end
    end
  end
end
