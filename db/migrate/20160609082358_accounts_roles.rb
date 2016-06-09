class AccountsRoles < ActiveRecord::Migration
  def change
    create_table :gram_accounts_roles do |t|
      t.integer :account_id
      t.integer :role_id

      t.timestamps null: false
    end
  end
end
