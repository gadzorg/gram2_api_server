class AddIsFromLegacyGram1ToMasterDataAccounts < ActiveRecord::Migration
  def change
    add_column :gram_accounts, :is_from_legacy_gram1, :boolean
  end
end
