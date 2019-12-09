class CreateClients < ActiveRecord::Migration[4.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :password
      t.string :description
      t.boolean :active

      t.timestamps null: false
    end
  end
end
