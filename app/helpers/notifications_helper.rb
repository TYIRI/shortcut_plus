module NotificationsHelper
  def unchecked_notifications
    notifications = current_user.passive_notifications.where(checked: false)
    notifications = notifications.recipe_like_off unless current_user.notification_recipe_like
    notifications = notifications.comment_like_off unless current_user.notification_comment_like
    notifications = notifications.recipe_comment_off unless current_user.notification_recipe_comment
    notifications = notifications.others_recipe_comment_off unless current_user.notification_others_recipe_comment
    @notifications = notifications
  end
end
