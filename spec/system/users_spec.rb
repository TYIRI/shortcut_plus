require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ユーザー新規登録' do
    context 'フォームの入力値が正常' do
      it '登録確認メールが送信されること' do
        visit root_path
        click_link 'ユーザー登録'
        check '利用規約とプライバシーポリシーに同意する'
        fill_in 'ユーザー名', with: 'user-name'
        fill_in 'メールアドレス', with: 'email@example.com'
        fill_in 'パスワード', with: 'password1'
        fill_in 'パスワード再入力', with: 'password1'
        click_button '登録'
        expect(page).to have_content '登録確認メールを送信しました。'
        expect(current_path).to eq users_path
      end
    end

    context 'フォームが未入力' do
      it '登録に失敗すること' do
        visit new_user_path
        check '利用規約とプライバシーポリシーに同意する'
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード再入力', with: ''
        click_button '登録'
        expect(current_path).to eq new_user_path
      end
    end

    context '登録済みのユーザー名を使用' do
      it '登録に失敗すること' do
        existed_user = create(:user)
        visit new_user_path
        check '利用規約とプライバシーポリシーに同意する'
        fill_in 'ユーザー名', with: existed_user.name
        fill_in 'メールアドレス', with: 'email@example.com'
        fill_in 'パスワード', with: 'password1'
        fill_in 'パスワード再入力', with: 'password1'
        click_button '登録'
        expect(page).to have_content 'このユーザー名はすでに使われています'
        expect(current_path).to eq new_user_path
      end
    end

    context '登録済みのメールアドレスを使用' do
      it '登録に失敗すること' do
        existed_user = create(:user)
        visit new_user_path
        check '利用規約とプライバシーポリシーに同意する'
        fill_in 'ユーザー名', with: 'user-name'
        fill_in 'メールアドレス', with: existed_user.email
        fill_in 'パスワード', with: 'password1'
        fill_in 'パスワード再入力', with: 'password1'
        click_button '登録'
        expect(page).to have_content 'メールアドレスはすでに存在します'
        expect(current_path).to eq users_path
      end
    end

    context '利用規約とプライバシーポリシーに未同意' do
      it '登録に失敗すること' do
        visit new_user_path
        uncheck '利用規約とプライバシーポリシーに同意する'
        fill_in 'ユーザー名', with: 'user-name'
        fill_in 'メールアドレス', with: 'email@example.com'
        fill_in 'パスワード', with: 'password1'
        fill_in 'パスワード再入力', with: 'password1'
        click_button '登録'
        expect(page).to have_content 'チェックが必要です'
        expect(current_path).to eq new_user_path
      end
    end
  end

  describe 'ユーザー編集' do
    let(:user) { create(:user) }

    before do
      activate user
      sign_in_as user
    end

    context 'フォームの入力値が正常' do
      it 'ユーザー編集が成功すること' do
        visit root_path
        find(".btn-dropdown").click
        click_link '設定'
        attach_file 'user_avatar', file_fixture("test-logo.PNG"), make_visible: true
        fill_in 'ユーザー名', with: 'edit-name'
        click_button '変更を保存'
        expect(current_path).to eq settings_path
        within('.btn-dropdown') do
          expect(page).to have_content 'edit-name'
        end
      end

      it 'パスワード変更が成功すること' do
        visit settings_path
        fill_in 'パスワード変更', with: 'password2'
        fill_in 'パスワード再入力', with: 'password2'
        click_button '変更を保存'
        expect(current_path).to eq settings_path
      end
    end

    context '登録済みのユーザー名を使用' do
      it 'ユーザー編集に失敗すること' do
        existed_user = create(:user)
        visit settings_path
        fill_in 'ユーザー名', with: existed_user.name
        click_button '変更を保存'
        expect(page).to have_content 'ユーザー名 はすでに使用されています'
        within('.btn-dropdown') do
          expect(page).to have_content user.name
        end
      end
    end
  end

  describe 'ユーザー削除' do
    let(:user) { create(:user) }

    it 'ユーザーの削除が成功すること' do
      activate user
      sign_in_as user
      visit settings_path
      expect {
        page.accept_confirm do
          click_link 'アカウントを削除する'
        end
        expect(current_path).to eq root_path
      }.to change(User, :count).by(-1)
    end
  end
end
