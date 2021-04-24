class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action -> { redirect_to root_path }, if: :logged_in?
  before_action :set_categories

  def create
    @user = User.find_by_email(params[:password_reset][:email])
    @email = params[:password_reset][:email]
    if @user
      @user.deliver_reset_password_instructions!
    end
    render 'password_resets/thanks'
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      render 'password_resets/complete'
    else
      render :edit
    end
  end
end
