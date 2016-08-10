class AddGappsIdToMasterDataAccounts < ActiveRecord::Migration
  def change
    add_column :gram_accounts, :gapps_id, :string, :unique => true, :index => true
    remove_column :gram_accounts, :gapps_email
  end
end