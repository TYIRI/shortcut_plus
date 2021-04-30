class ContactsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_categories

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_email(@contact).deliver_now
      render 'contacts/thanks'
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
