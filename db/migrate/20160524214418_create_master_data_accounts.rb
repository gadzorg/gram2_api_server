class CreateMasterDataAccounts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :gram_accounts do |t|
      t.uuid :uuid, :unique => true, :index => true
      t.string :hruid, :unique => true, :unsigned => true, :index => true
      t.integer :id_soce, :unique => true, :unsigned => true, :index => true
      t.boolean :enabled, :default => true
      t.string :password, :null => false
      t.string :lastname
      t.string :firstname
      t.string :birthname
      t.string :birth_firstname
      t.string :email
      t.string :gapps_email
      t.string :password
      t.string :birthdate
      t.string :deathdate
      t.string :gender
      t.boolean :is_gadz
      t.boolean :is_student
      t.string :school_id
      t.boolean :is_alumni
      t.string :date_entree_ecole
      t.string :date_sortie_ecole
      t.string :ecole_entree
      t.string :buque_texte
      t.string :buque_zaloeil
      t.string :gadz_fams
      t.string :gadz_fams_zaloeil
      t.string :gadz_proms_principale
      t.string :gadz_proms_secondaire
      t.string :avatar_url
      t.string :description 

      t.timestamps null: false
  end


     # ALTER TABLE profiles ALTER COLUMN uuid SET DEFAULT uuid_generate_v4();
  execute <<-SQL
     CREATE SEQUENCE id_soce_seq START 1000;
     ALTER SEQUENCE id_soce_seq OWNED BY gram_accounts.id_soce;
     ALTER TABLE gram_accounts ALTER COLUMN id_soce SET DEFAULT nextval('id_soce_seq');
    SQL
  end
  def self.down
    drop_table :gram_accounts

    execute <<-SQL
      DROP SEQUENCE id_soce_seq;
    SQL
  end
end