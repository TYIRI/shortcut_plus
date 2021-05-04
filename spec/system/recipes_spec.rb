require 'rails_helper'

RSpec.describe "Recipes", type: :system do
  describe 'レシピ新規作成' do
    let(:user) { create(:user) }

    before do
      activate user
      sign_in_as user
    end

    context 'フォームの入力値が正常' do
      it 'レシピの公開に成功すること' do
        category = create(:category)
        visit root_path
        click_link 'レシピ作成'
        fill_in 'recipe_title', with: 'レシピタイトル'
        select category.name, from: 'recipe_category_id'
        fill_in 'タグ(スペース区切りで10個まで)', with: 'タグ'
        find(:css, 'trix-editor').set("レシピ本文")
        page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
          page.find('.trix-button--icon-attach').click          
        end
        fill_in 'recipe_shortcut_id', with: 'shortcutid'
        expect {
          click_button '公開する'
          expect(current_path).to eq recipe_path(Recipe.last)
          expect(page).to have_content 'レシピタイトル'
        }.to change(Recipe, :count).by(1)
      end

      it 'レシピの下書きに成功すること' do
        category = create(:category)
        visit new_recipe_path
        fill_in 'recipe_title', with: 'レシピタイトル'
        select category.name, from: 'recipe_category_id'
        fill_in 'タグ(スペース区切りで10個まで)', with: 'タグ'
        find(:css, 'trix-editor').set("レシピ本文")
        page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
          page.find('.trix-button--icon-attach').click          
        end
        fill_in 'recipe_shortcut_id', with: 'shortcutid'
        expect {
          click_button '下書きに保存する'
          expect(current_path).to eq my_recipes_path
        }.to change(Recipe, :count).by(1)
      end

      it '公開レシピがマイレシピに表示されること' do
        category = create(:category)
        visit new_recipe_path
        fill_in 'recipe_title', with: 'レシピタイトル'
        select category.name, from: 'recipe_category_id'
        fill_in 'タグ(スペース区切りで10個まで)', with: 'タグ'
        find(:css, 'trix-editor').set("レシピ本文")
        fill_in 'recipe_shortcut_id', with: 'shortcutid'
        click_button '公開する'
        find(".btn-dropdown").click
        click_link 'マイレシピ'
        expect(current_path).to eq my_recipes_path
        expect(page).to have_content 'レシピタイトル'
      end

      it '下書きレシピがマイレシピに表示されること' do
        category = create(:category)
        visit new_recipe_path
        fill_in 'recipe_title', with: 'レシピタイトル'
        select category.name, from: 'recipe_category_id'
        fill_in 'タグ(スペース区切りで10個まで)', with: 'タグ'
        find(:css, 'trix-editor').set("レシピ本文")
        fill_in 'recipe_shortcut_id', with: 'shortcutid'
        click_button '下書きに保存する'
        find("a[href='#item2']").click
        expect(current_path).to eq my_recipes_path
        expect(page).to have_content 'レシピタイトル'
      end
    end

    context 'フォームが未入力' do
      it 'レシピの公開に失敗すること' do
        visit new_recipe_path
        fill_in 'recipe_title', with: ''
        select 'カテゴリ選択', from: 'recipe_category_id'
        fill_in 'タグ(スペース区切りで10個まで)', with: ''
        find(:css, 'trix-editor').set("")
        fill_in 'recipe_shortcut_id', with: ''
        expect {
          click_button '公開する'
          expect(current_path).to eq recipes_path
          expect(page).to have_content 'タイトル を入力してください'
          expect(page).to have_content 'カテゴリ を選択してください'
          expect(page).to have_content '本文 を入力してください'
        }.to_not change(Recipe, :count)
      end

      it 'レシピの下書きに成功すること' do
        visit new_recipe_path
        fill_in 'recipe_title', with: ''
        select 'カテゴリ選択', from: 'recipe_category_id'
        fill_in 'タグ(スペース区切りで10個まで)', with: ''
        find(:css, 'trix-editor').set("")
        fill_in 'recipe_shortcut_id', with: ''
        expect {
          click_button '下書きに保存する'
          expect(current_path).to eq my_recipes_path
        }.to change(Recipe, :count).by(1)
      end
    end
  end

  describe 'レシピ編集' do
    let(:user) { create(:user) }
    
    before do
      activate user
      sign_in_as user
    end

    describe '公開レシピ' do
      context 'フォームの入力値が正常' do
        it 'レシピの更新に成功すること' do
          recipe = create(:recipe, :published, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: '更新レシピタイトル'
          select category.name, from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: '更新レシピタグ'
          find(:css, 'trix-editor').set("更新レシピ本文")
          page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
            page.find('.trix-button--icon-attach').click          
          end
          fill_in 'recipe_shortcut_id', with: 'updateshortcutid'
          expect {
            click_button '更新する'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content 'レシピタイトル'
          }.to_not change(Recipe, :count)
        end

        it 'レシピの公開停止に成功すること' do
          recipe = create(:recipe, :published, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: '更新レシピタイトル'
          select category.name, from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: '更新レシピタグ'
          find(:css, 'trix-editor').set("更新レシピ本文")
          page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
            page.find('.trix-button--icon-attach').click          
          end
          fill_in 'recipe_shortcut_id', with: 'updateshortcutid'
          expect {
            click_button '公開を停止する'
            expect(current_path).to eq my_recipes_path
            expect(page).to_not have_content '更新レシピタイトル'
          }.to_not change(Recipe, :count)
        end
      end

      context 'フォームが未入力' do
        it 'レシピの更新に失敗すること' do
          recipe = create(:recipe, :published, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: ''
          select 'カテゴリ選択', from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: ''
          find(:css, 'trix-editor').native.clear
          fill_in 'recipe_shortcut_id', with: ''
          expect {
            click_button '更新する'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content 'タイトル を入力してください'
            expect(page).to have_content 'カテゴリ を選択してください'
            expect(page).to have_content '本文 を入力してください'
          }.to_not change(Recipe, :count)
        end

        it 'レシピの公開停止に成功すること' do
          recipe = create(:recipe, :published, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: ''
          select 'カテゴリ選択', from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: ''
          find(:css, 'trix-editor').native.clear
          fill_in 'recipe_shortcut_id', with: ''
          expect {
            click_button '公開を停止する'
            expect(current_path).to eq my_recipes_path
            expect(page).to_not have_content recipe.title
          }.to_not change(Recipe, :count)
        end
      end      
    end

    describe '下書きレシピ' do
      context 'フォームの入力値が正常' do
        it 'レシピの公開に成功すること' do
          recipe = create(:recipe, :draft, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#item2']").click
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: '更新レシピタイトル'
          select category.name, from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: '更新レシピタグ'
          find(:css, 'trix-editor').set("更新レシピ本文")
          page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
            page.find('.trix-button--icon-attach').click          
          end
          fill_in 'recipe_shortcut_id', with: 'updateshortcutid'
          expect {
            click_button '公開する'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content '更新レシピタイトル'
          }.to_not change(Recipe, :count)
        end

        it 'レシピの下書き保存に成功すること' do
          recipe = create(:recipe, :draft, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#item2']").click
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: '更新レシピタイトル'
          select category.name, from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: '更新レシピタグ'
          find(:css, 'trix-editor').set("更新レシピ本文")
          page.attach_file(Rails.root + 'spec/fixtures/files/test-logo.PNG') do
            page.find('.trix-button--icon-attach').click          
          end
          fill_in 'recipe_shortcut_id', with: 'updateshortcutid'
          expect {
            click_button '下書きに保存する'
            expect(current_path).to eq my_recipes_path
            expect(page).to_not have_content '更新レシピタイトル'
          }.to_not change(Recipe, :count)
        end
      end

      context 'フォームが未入力' do
        it 'レシピの公開に失敗すること' do
          recipe = create(:recipe, :draft, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#item2']").click
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: ''
          select 'カテゴリ選択', from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: ''
          find(:css, 'trix-editor').native.clear
          fill_in 'recipe_shortcut_id', with: ''
          expect {
            click_button '公開する'
            expect(current_path).to eq recipe_path(recipe)
            expect(page).to have_content 'タイトル を入力してください'
            expect(page).to have_content 'カテゴリ を選択してください'
            expect(page).to have_content '本文 を入力してください'
          }.to_not change(Recipe, :count)
        end

        it 'レシピの下書き保存に成功すること' do
          recipe = create(:recipe, :draft, user: user)
          category = create(:category)
          visit my_recipes_path
          find("a[href='#item2']").click
          find("a[href='#{edit_recipe_path(recipe)}']").click
          fill_in 'recipe_title', with: ''
          select 'カテゴリ選択', from: 'recipe_category_id'
          fill_in 'タグ(スペース区切りで10個まで)', with: ''
          find(:css, 'trix-editor').native.clear
          fill_in 'recipe_shortcut_id', with: ''
          expect {
            click_button '下書きに保存する'
            expect(current_path).to eq my_recipes_path
            expect(page).to_not have_content recipe.title
          }.to_not change(Recipe, :count)
        end
      end      
    end
  end

  describe 'レシピ削除' do
    let(:user) { create(:user) }

    before do
      activate user
      sign_in_as user
    end

    it '公開レシピの削除に成功すること' do
      recipe = create(:recipe, :published, user: user)
      category = create(:category)
      visit my_recipes_path
      expect {
        page.accept_confirm do
          find("a[data-method='delete']").click
        end
        expect(current_path).to eq my_recipes_path
      }.to change(Recipe, :count).by(-1)
    end

    it '下書きレシピの削除に成功すること' do
      recipe = create(:recipe, :draft, user: user)
      category = create(:category)
      visit my_recipes_path
      find("a[href='#item2']").click
      expect {
        page.accept_confirm do
          find("a[data-method='delete']").click
        end
        expect(current_path).to eq my_recipes_path
      }.to change(Recipe, :count).by(-1)
    end
  end

  describe 'レシピ検索' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, :published) }

    context 'カテゴリで検索' do
      it '対象レシピが検索されること' do
        category = recipe.category.name
        visit root_path
        select category, from: 'q_category_id'
        click_button '検索'
        expect(page).to have_current_path search_path, ignore_query: true
        expect(page).to have_content recipe.title
      end

      it '対象外レシピが検索されないこと' do
        category = recipe.category.name
        other_category = create(:category)
        visit root_path
        select other_category.name, from: 'q_category_id'
        click_button '検索'
        expect(page).to have_current_path search_path, ignore_query: true
        expect(page).to_not have_content recipe.title
      end
    end

    context 'キーワードで検索' do
      it '対象レシピが検索されること' do
        visit root_path
        fill_in 'q_title_and_content', with: recipe.title
        click_button '検索'
        expect(page).to have_current_path search_path, ignore_query: true
        expect(page).to have_content recipe.title
      end

      it '対象外レシピが検索されないこと' do
        recipe = create(:recipe, :published)
        other_recipe = create(:recipe, :published)
        visit root_path
        fill_in 'q_title_and_content', with: other_recipe.title
        click_button '検索'
        expect(page).to have_current_path search_path, ignore_query: true
        expect(page).to_not have_content recipe.title
      end

      it '下書きレシピが検索されないこと' do
        recipe = create(:recipe, :draft)
        visit root_path
        fill_in 'q_title_and_content', with: recipe.title
        click_button '検索'
        expect(page).to have_current_path search_path, ignore_query: true
        expect(page).to_not have_content recipe.title
      end
    end
  end
end
