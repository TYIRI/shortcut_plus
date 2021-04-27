class NewsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_categories

  def index
    @news = News.all
  end

  def show
    @news = News.find(params[:id])
  end
end
