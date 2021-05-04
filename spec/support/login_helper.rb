module LoginHelpers
  def sign_in_as(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password1'
    click_button 'ログイン'
  end
end
