class MasterData::Account < MasterData::Base

	require "hruid_service"
	require "ldap_daemon"

  resourcify

  #relations
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :roles
  has_many :alias

  #callbacks
  before_validation :generate_uuid_if_empty
  before_validation(:on => :create) do 
  	#set id_soce
  	if attribute_present?(:id_soce)
  		set_id_soce_seq_value_to_max
  	else
  		self.id_soce = next_id_soce_seq_value
  	end
  	# set hruid if empty
  	self.generate_hruid
  end
  after_save :request_account_ldap_sync
  after_create :account_completer

  #model validations
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :uuid, uniqueness: true
  validates :id_soce, uniqueness: true, presence: true, numericality: { only_integer: true }
  validates :enabled, :inclusion => {:in => [true, false]}
  validates :password, presence: true
  validates :hruid,  uniqueness: true
  validates :gapps_id,  uniqueness: true, allow_nil: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
	validates :gender, inclusion: {in: %w(male female)}, allow_nil: true
  validates :is_gadz, :inclusion => {:in => [true, false]}
  validates :buque_texte, format: { with: /\A[a-zA-Z0-9\'\-\s]\z/}, allow_nil: true
  validates :gadz_fams, format: { with: /\A[0-9\(\)\!\-\s]\z/}, allow_nil: true

  def next_id_soce_seq_value
  	result = self.class.connection.execute("SELECT nextval('id_soce_seq')")
  	result[0]['nextval']
  end

  def set_id_soce_seq_value_to_max
  	self.class.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, ["SELECT setval('id_soce_seq',(SELECT GREATEST((SELECT MAX(id_soce) FROM gram_accounts),?)))",self.id_soce]))
  end

  def generate_hruid
  	self.hruid ||= HruidService::generate(self)
  end

  ################# Aliases #################
  def aliases
    self.alias
  end

  def add_alias connection_alias
    self.alias << connection_alias unless self.alias.exists?(connection_alias.id)
  end

  def remove_alias connection_alias
    self.groups.detete connection_alias
  end

  def add_new_alias alias_name
    new_alias = MasterData::Alias.new(name: alias_name)
    self.add_alias(new_alias)
    new_alias.save # alias validation ensures alias uniqness
  end

  def remove_all_alias
    self.alias.destroy_all
  end

  ################# Groups #################
  def add_to_group group
    #check if account already in tihs group
    self.groups << group unless self.groups.exists?(group.id)
  end

  def remove_from_group group
    self.groups.delete group
  end

  ################# Roles #################
  def add_role role
    #check if account already in tihs group
    self.roles << role unless self.roles.exists?(role.id)
  end

  def revoke_role role
    self.roles.delete role
  end

  ############ Account completer #############
  # generate all standard information when creating
  # a new account
  def account_completer
    # generate alias
    alias_list = AliasService.generate_list(self)
    alias_list.each { |a| self.add_new_alias(a) }
  end

  ################# LDAP #################
  def request_account_ldap_sync(ldap_daemon = LdapDaemon.new, account = self)
    ldap_daemon.request_account_update(account)
  end

end
