class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_change_digest, :string, default: nil
    add_column :users, :email_change_token_expires_at, :datetime, default: nil
    add_column :users, :email_change_email_sent_at, :datetime, default: nil

    add_index :users, :email_change_digest
  end
end
