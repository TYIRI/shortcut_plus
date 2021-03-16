class ApplicationController < ActionController::Base
  include Pundit
  before_action :require_login

  protected

  def not_authenticated
    redirect_to login_path
  end
end
