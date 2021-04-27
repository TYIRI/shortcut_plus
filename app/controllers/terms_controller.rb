class TermsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  before_action :set_categories

  def index; end
end
