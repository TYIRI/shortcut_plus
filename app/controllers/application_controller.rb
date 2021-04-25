class ApplicationController < ActionController::Base
  include Pundit
  before_action :require_login

  rescue_from StandardError, with: :error_500
  rescue_from NoMemoryError, ScriptError, Interrupt, SecurityError, SignalException, SystemStackError, with: :only_logging
  rescue_from ActiveRecord::RecordNotFound, with: :error_404

  protected

  def not_authenticated
    redirect_to login_path
  end

  private

  def set_categories
    @categories = Category.all
  end

  def error_404(error = nil)
    logger.error error.message if error
    logger.error error.backtrace.join("\n\n") if error
    render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found
  end

  def error_500(error = nil)
    logger.error error.message if error
    logger.error error.backtrace.join("\n\n") if error
    render file: Rails.root.join('public', '500.html'), layout: false, status: :internal_server_error
  end
  
  def only_logging(error = nil)
    logger.error error.message if error
    logger.error error.backtrace.join("\n\n") if error
  end
end
