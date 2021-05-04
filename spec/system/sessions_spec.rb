require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'ヘッダー表示' do
      it 'ユーザー登録リンクが表示されること' do
        visit root_path
        expect(page).to have_link 'ユーザー登録'
      end

      it 'ログインリンクが表示されること' do
        visit root_path
        expect(page).to have_link 'ログイン'
      end
    end

    context 'フォームの入力値が正常' do
      it 'ログインが成功すること' do
        activate user
        visit root_path
        click_link 'ログイン'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password1'
        click_button 'ログイン'

        expect(current_path).to eq root_path
        expect(page).to have_content user.name
      end
    end

    context 'フォームが未入力' do
      it 'ログインが失敗すること' do
        activate user
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'

        expect(current_path).to eq login_path
        expect(page).to have_content 'メールアドレスまたはパスワードに誤りがあります'
      end
    end
  end

  describe 'ログイン後' do
    before do
      activate user
      sign_in_as user
    end

    context 'ヘッダー表示' do
      it 'ユーザー登録リンクが表示されないこと' do
        expect(page).to_not have_link 'ユーザー登録'
      end

      it 'ログインリンクが表示されること' do
        expect(page).to_not have_link 'ログイン'
      end
    end

    context 'ユーザー登録画面にアクセスする' do
      it 'トップページに遷移すること' do
        visit new_user_path
        expect(current_path).to eq root_path
      end
    end

    context 'ログイン画面にアクセスする' do
      it 'トップページに遷移すること' do
        visit login_path
        expect(current_path).to eq root_path
      end
    end

    context 'ログアウトボタンをクリック' do
      it 'ログアウトが成功すること' do
        visit root_path
        find(".btn-dropdown").click
        click_link 'ログアウト'
        expect(current_path).to eq root_path
        expect(page).to_not have_content user.name
      end
    end
  end
end
