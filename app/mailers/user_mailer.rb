class UserMailer < ApplicationMailer

  def activation_needed_email(user)
    @user = user
    @url = "https://www.shortcutplus.com/users/#{user.activation_token}/activate"
    mail to: user.email, subject: 'ShortcutPlusユーザー登録のご確認'
  end

  def activation_success_email(user)
    @user = user
    @url = 'https://www.shortcutplus.com/login'
    mail to: user.email, subject: 'ShortcutPlusユーザー登録完了のご案内'
  end

  def reset_password_email(user)
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token)
    mail to: user.email, subject: 'ログインパスワードのリセット'
  end

  def email_change_email(user, new_email)
    @user = user
    @url = edit_email_change_url(@user.email_change_token, email: new_email)
    mail to: new_email, subject: 'メールアドレス変更のご案内'
  end
end
