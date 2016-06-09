class CreateMasterDataGroups < ActiveRecord::Migration
  def change
    create_table :gram_groups do |t|
      t.string :guid
      t.string :name
      t.string :short_name
      t.string :description

      t.timestamps null: false
    end
  end
end
