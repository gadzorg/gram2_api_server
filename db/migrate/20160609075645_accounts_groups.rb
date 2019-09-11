class AccountsGroups < ActiveRecord::Migration[4.2]
  def change
  	create_table :gram_accounts_groups do |t|
      t.integer :account_id
      t.integer :group_id

      t.timestamps null: false
    end
  end
end
