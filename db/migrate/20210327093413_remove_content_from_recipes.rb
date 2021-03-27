class RemoveContentFromRecipes < ActiveRecord::Migration[6.1]
  def change
    remove_column :recipes, :content, :text
  end
end
