class AddNotificationsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :notification_recipe_like, :boolean, default: true, null: false
    add_column :users, :notification_comment_like, :boolean, default: true, null: false
    add_column :users, :notification_recipe_comment, :boolean, default: true, null: false
    add_column :users, :notification_others_recipe_comment, :boolean, default: true, null: false
  end
end
