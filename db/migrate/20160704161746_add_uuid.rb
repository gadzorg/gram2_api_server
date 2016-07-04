class AddUuid < ActiveRecord::Migration
  def change
      rename_column :gram_groups, :guid, :uuid
      add_reference :gram_groups, :uuid, :unique => true, :index => true
      add_column :gram_roles, :uuid, :string, :unique => true, :index => true
  end
end
