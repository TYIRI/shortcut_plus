class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :content
      t.integer :status, default: 0, null: false
      t.string :shortcut_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
