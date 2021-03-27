class ChangeRecipeTagsToTagmaps < ActiveRecord::Migration[6.1]
  def change
    rename_table :recipe_tags, :tag_maps
  end
end
