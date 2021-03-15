class SessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:user][:email], params[:user][:password])
    if @user
      redirect_to root_path
    else
      render :new
    end
  end
end
