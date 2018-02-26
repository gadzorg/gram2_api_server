class AddGadzCentreToMasterDataAccount < ActiveRecord::Migration
  def change
    add_column :gram_accounts, :gadz_centre_principal, :string
    add_column :gram_accounts, :gadz_centre_secondaire, :string
  end
end
