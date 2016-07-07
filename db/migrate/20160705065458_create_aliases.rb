class CreateAliases < ActiveRecord::Migration
  def change
    create_table :gram_aliases do |t|
      t.integer :account_id
      t.string :name

      t.timestamps null: false
    end
  end
end
