class MasterData::AccountSerializer < BaseSerializer
  has_many :aliases, serializer: MasterData::AliasSerializer
  has_many :groups, serializer: MasterData::GroupSerializer
  has_many :roles, serializer: MasterData::RoleSerializer

  attributes :uuid, :hruid, :id_soce, :enabled, :lastname, :firstname, :birthname, :birth_firstname, :email, :gapps_id, :birthdate, :deathdate, :gender, :is_gadz, :is_student, :school_id, :is_alumni, :date_entree_ecole, :date_sortie_ecole, :ecole_entree, :buque_texte, :buque_zaloeil, :gadz_fams, :gadz_fams_zaloeil, :gadz_proms_principale, :gadz_proms_secondaire, :avatar_url, :description, :audit_status, :audit_comments, :is_from_legacy_gram1, :emergency_email
  attributes :url

    attribute :password, if: -> {instance_options[:show_password_hash]}


  def url
  	api_v2_account_path(object)
  end

  # Filter account hash
  def password
    client = view_context.current_client
    Pundit.policy(client, object).show_password_hash? ? object.password : "HIDDEN"
  end
end
