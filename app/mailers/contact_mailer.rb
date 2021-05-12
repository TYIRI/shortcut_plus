class ContactMailer < ApplicationMailer

  def contact_email(contact)
    @contact = contact
    mail to: 'shortcutplus.info@gmail.com', subject: 'お問い合わせ通知'
  end
end
