class CreateMasterDataAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :uuid
      t.string :hruid
      t.string :id_soce
      t.boolean :enabled
      t.string :password
      t.string :email

      t.timestamps null: false
    end
  end
end
