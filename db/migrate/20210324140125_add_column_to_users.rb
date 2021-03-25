class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :unconfirmed_email, :string, default: nil
  end
end
