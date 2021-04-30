class ContactMailer < ApplicationMailer

  def contact_email(contact)
    @contact = contact
    mail to: ENV['TOMAIL'], subject: 'お問い合わせ通知'
  end
end
