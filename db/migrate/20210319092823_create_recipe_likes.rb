class CreateRecipeLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_likes do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :recipe_likes, [:recipe_id, :user_id], unique: true
  end
end
