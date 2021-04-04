class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action -> { redirect_to root_path }, if: :logged_in?, only: %i[new create]

  def new; end

  def create
    @user = login(params[:user][:email], params[:user][:password], params[:user][:remember_me])
    if @user
      redirect_to root_path
    else
      @failed = true
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
