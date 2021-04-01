class NotificationsController < ApplicationController
  def index
    notifications = current_user.passive_notifications
    notifications.where(checked: false).each do |notification|
      notification.update_attribute(:checked, true)
    end
    notifications = notifications.recipe_like_off unless current_user.notification_recipe_like
    notifications = notifications.comment_like_off unless current_user.notification_comment_like
    notifications = notifications.recipe_comment_off unless current_user.notification_recipe_comment
    notifications = notifications.others_recipe_comment_off unless current_user.notification_others_recipe_comment
    @notifications = notifications.page(params[:page]).per(5)
  end
end
