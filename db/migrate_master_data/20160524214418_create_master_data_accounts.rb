class CreateMasterDataAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :uuid
      t.string :hruid
      t.string :id_soce
      t.boolean :enabled
      t.string :password
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
  end
end
