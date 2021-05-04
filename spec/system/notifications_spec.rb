require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  describe 'バッジ' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    
    before do
      activate user
      sign_in_as user
      activate other_user
    end

    context '通知なし' do
      it 'バッジに新着アイコンが表示されないこと' do
        visit root_path
        within('#notification-badge') do
          expect(page).to_not have_selector "svg[data-icon='circle']"
        end
      end
    end

    context '通知ありで未読' do
      it 'バッジに新着アイコンが表示されること' do
        recipe = create(:recipe, :published, user: user)
        create(:notification, :recipe_like_unchecked, visitor_id: other_user.id, visited_id: user.id, recipe_id: recipe.id)
        visit root_path
        within('#notification-badge') do
          expect(page).to have_selector "svg[data-icon='circle']"
        end
      end
    end

    context '通知ありで既読' do
      it 'バッジに新着アイコンが表示されないこと' do
        recipe = create(:recipe, :published, user: user)
        create(:notification, :recipe_like_checked, visitor_id: other_user.id, visited_id: user.id, recipe_id: recipe.id)
        visit root_path
        within('#notification-badge') do
          expect(page).to_not have_selector "svg[data-icon='circle']"
        end
      end
    end

    context '通知しないに設定' do
      it 'バッジに新着アイコンが表示されないこと' do
        visit settings_path
        choose 'user_notification_recipe_like_false'
        choose 'user_notification_comment_like_false'
        choose 'user_notification_recipe_comment_false'
        choose 'user_notification_others_recipe_comment_false'
        click_button '変更を保存'
        recipe = create(:recipe, :published, user: user)
        create(:notification, :recipe_like_unchecked, visitor_id: other_user.id, visited_id: user.id, recipe_id: recipe.id)
        visit root_path
        within('#notification-badge') do
          expect(page).to_not have_selector "svg[data-icon='circle']"
        end
      end
    end
  end

  describe '通知モーダル' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    
    before do
      activate user
      sign_in_as user
      activate other_user
    end

    after(:each) do
      errors = page.driver.browser.manage.logs.get(:browser)
      if errors.present?
        message = errors.map(&:message).join("\n")
        puts message
      end
    end

    context '通知なし' do
      it '通知が表示されないこと' do
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content '通知はありません'
        end
      end
    end
    
    context '通知あり（マイレシピにいいね）' do
      it '通知が表示されること' do
        recipe = create(:recipe, :published, user: user)
        create(:recipe_like, recipe: recipe, user: other_user)
        notification = create(:notification, :recipe_like_unchecked, visitor_id: other_user.id, visited_id: user.id, recipe_id: recipe.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content other_user.name
          expect(page).to have_selector "a[href='#{labo_path(other_user)}']"
          expect(page).to have_selector "a[href='#{recipe_path(recipe)}']"
          expect(page).to have_content 'いいねしました'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end

    context '通知あり（コメントにいいね）' do
      it '通知が表示されること' do
        recipe = create(:recipe, :published, user: user)
        comment = create(:comment, recipe: recipe, user: user)
        create(:comment_like, comment: comment, user: other_user)
        notification = create(:notification, :comment_like_unchecked, visitor_id: other_user.id, visited_id: user.id, comment_id: comment.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content other_user.name
          expect(page).to have_selector "a[href='#{labo_path(other_user)}']"
          expect(page).to have_selector "a[href='#{recipe_path(recipe)}']"
          expect(page).to have_content 'いいねしました'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end

    context '通知あり（マイレシピに新しいコメント）' do
      it '通知が表示されること' do
        recipe = create(:recipe, :published, user: user)
        comment = create(:comment, recipe: recipe, user: other_user)
        notification = create(:notification, :recipe_comment_unchecked, visitor_id: other_user.id, visited_id: user.id, recipe_id: recipe.id, comment_id: comment.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content other_user.name
          expect(page).to have_selector "a[href='#{labo_path(other_user)}']"
          expect(page).to have_selector "a[href='#{recipe_path(recipe)}']"
          expect(page).to have_content 'コメントしました'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end

    context '通知あり（コメントしたレシピに新しいコメント）' do
      it '通知が表示されること' do
        recipe = create(:recipe, :published, user: other_user)
        comment = create(:comment, recipe: recipe, user: user)
        other_comment_user = create(:user)
        activate other_comment_user
        other_comment = create(:comment, recipe: recipe, user: other_comment_user)
        notification = create(:notification, :others_recipe_comment_unchecked, visitor_id: other_comment_user.id, visited_id: user.id, recipe_id: recipe.id, comment_id: other_comment.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content other_comment_user.name
          expect(page).to have_selector "a[href='#{labo_path(other_comment_user)}']"
          expect(page).to have_content other_user.name
          expect(page).to have_selector "a[href='#{recipe_path(recipe)}']"
          expect(page).to have_content 'コメントしました'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end

    context '通知しないに設定（マイレシピにいいね）' do
      it '通知が表示されないこと' do
        visit settings_path
        choose 'user_notification_recipe_like_false'
        click_button '変更を保存'
        recipe = create(:recipe, :published, user: user)
        create(:recipe_like, recipe: recipe, user: other_user)
        notification = create(:notification, :recipe_like_unchecked, visitor_id: other_user.id, visited_id: user.id, recipe_id: recipe.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content '通知はありません'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end

    context '通知しないに設定（コメントにいいね）' do
      it '通知が表示されないこと' do
        visit settings_path
        choose 'user_notification_comment_like_false'
        click_button '変更を保存'
        recipe = create(:recipe, :published, user: user)
        comment = create(:comment, recipe: recipe, user: user)
        create(:comment_like, comment: comment, user: other_user)
        notification = create(:notification, :comment_like_unchecked, visitor_id: other_user.id, visited_id: user.id, comment_id: comment.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content '通知はありません'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end

    context '通知しないに設定（マイレシピに新しいコメント）' do
      it '通知が表示されないこと' do
        visit settings_path
        choose 'user_notification_recipe_comment_false'
        click_button '変更を保存'
        recipe = create(:recipe, :published, user: user)
        comment = create(:comment, recipe: recipe, user: other_user)
        notification = create(:notification, :recipe_comment_unchecked, visitor_id: other_user.id, visited_id: user.id, recipe_id: recipe.id, comment_id: comment.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content '通知はありません'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end

    context '通知しないに設定（コメントしたレシピに新しいコメント）' do
      it '通知が表示されないこと' do
        visit settings_path
        choose 'user_notification_others_recipe_comment_false'
        click_button '変更を保存'
        recipe = create(:recipe, :published, user: other_user)
        comment = create(:comment, recipe: recipe, user: user)
        other_comment_user = create(:user)
        activate other_comment_user
        other_comment = create(:comment, recipe: recipe, user: other_comment_user)
        notification = create(:notification, :others_recipe_comment_unchecked, visitor_id: other_comment_user.id, visited_id: user.id, recipe_id: recipe.id, comment_id: other_comment.id)
        visit root_path
        find("a[href='#{notifications_path}']").click
        within('#notification-modal') do
          expect(page).to have_content '通知はありません'
        end
        expect(notification.reload.checked).to eq(true)
      end
    end
  end
end
