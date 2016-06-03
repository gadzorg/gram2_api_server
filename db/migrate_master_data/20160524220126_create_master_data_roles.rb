class CreateMasterDataRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :application
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
