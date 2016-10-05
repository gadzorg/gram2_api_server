class Addmissingindex < ActiveRecord::Migration
  def change
    add_index :gram_accounts_groups, :account_id
    add_index :gram_accounts_groups, :group_id

    add_index :gram_aliases, :account_id

    add_index :gram_groups, :uuid, unique: true
    add_index :gram_groups, :short_name, unique: true

    add_index :gram_roles, :name
    add_index :gram_roles, :application
    add_index :gram_roles, :uuid, unique: true




  end
end
