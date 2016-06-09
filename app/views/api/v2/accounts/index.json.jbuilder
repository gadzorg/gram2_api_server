json.array!(@api_v2_accounts) do |api_v2_account|
  json.extract! api_v2_account, :id, :uuid, :hruid, :id_soce, :enabled, :password, :lastname, :firstname, :birthname, :birth_firstname, :email, :gapps_email, :password, :birthdate, :deathdate, :gender, :is_gadz, :is_student, :school_id, :is_alumni, :date_entree_ecole, :date_sortie_ecole, :ecole_entree, :buque_texte, :buque_zaloeil, :gadz_fams, :gadz_fams_zaloeil, :gadz_proms_principale, :gadz_proms_secondaire, :avatar_url, :description
  json.url api_v2_account_url(api_v2_account, format: :json)
end
