class AddEmployeeToMasterDataAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :gram_accounts, :is_soce_employee, :boolean, :default => false
  end
end
