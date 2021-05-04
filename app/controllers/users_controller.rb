class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create activate check_user]
  before_action -> { redirect_to root_path }, if: :logged_in?, only: %i[new create]
  before_action :set_categories

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @email = @user.email
      render 'users/thanks'
    else
      render :new
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to settings_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(current_user.id)
    @user.destroy!
    redirect_to root_path
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      render 'users/complete'
    else
      not_authenticated
    end
  end

  def check_user
    name = params[:fieldValue]
    user = User.where("name = ?", name).first
    if user.present?
      render json: ['user_name', false, 'このユーザー名はすでに使われています']
    else
      render json: ['user_name', true, '']
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :notification_recipe_like, :notification_comment_like, :notification_recipe_comment, :notification_others_recipe_comment, :agreement)
  end
end
