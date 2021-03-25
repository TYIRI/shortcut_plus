class EmailChangesController < ApplicationController
  def new; end

  def create
    @email = params[:email_change][:email]
    if @email
      current_user.generate_email_change_token
      current_user.send_email_change_email(@email)
      render 'email_changes/thanks'
      return
    end
    render :new
  end

  def edit
    user = User.find_by(unconfirmed_email: params[:email])
    if user&.authenticated_email_change_token?(params[:id]) && user.email_change_not_expired?
      user.update(email: user.unconfirmed_email)
      user.update(unconfirmed_email: nil, email_change_digest: nil, email_change_token_expires_at: nil)
    else
      not_authenticated
      return
    end
    redirect_to root_path
  end
end
