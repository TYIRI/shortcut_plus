class UserMailer < ApplicationMailer

  def activation_needed_email(user)
    @user = user
    @url = "http://localhost:3000/users/#{user.activation_token}/activate"
    mail to: user.email, subject: 'ShortcutPlus本登録のご案内'
  end

  def activation_success_email(user)
    @user = user
    @url = 'http://localhost:3000/login'
    mail to: user.email, subject: 'ShortcutPlusユーザー登録完了のご案内'
  end

  def reset_password_email(user)
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token)
    mail to: user.email, subject: 'ログインパスワードのリセット'
  end
end
