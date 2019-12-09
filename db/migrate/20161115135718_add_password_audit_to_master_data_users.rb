class AddPasswordAuditToMasterDataUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :gram_accounts, :updated_by, :string, default: ""
    add_column :gram_accounts, :password_updated_by, :string, default: ""
    add_column :gram_accounts, :password_updated_at, :datetime
  end
end