class AddEmergencyEmailToMasterDataAccounts < ActiveRecord::Migration
  def change
    add_column :gram_accounts, :emergency_email, :string
  end
end
