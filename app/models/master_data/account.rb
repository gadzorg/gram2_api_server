class MasterData::Account < MasterData::Base

  include GorgRabbitmqNotifier::ActiveRecordExtension

  NULL_ATTRS = %w(gapps_id email)

  rabbitmq_resource_type :account
  rabbitmq_id :uuid

	require "hruid_service"
	require "ldap_daemon"

  resourcify

  #relations
  has_and_belongs_to_many :groups,  after_add: :capture_add_association,  after_remove: :capture_del_association
  has_and_belongs_to_many :roles,  after_add: :capture_add_association,  after_remove: :capture_del_association
  has_many :alias, dependent: :delete_all, after_add: :capture_add_association,  after_remove: :capture_del_association

  #callbacks

  before_validation :generate_uuid_if_empty, unless: :uuid
  before_validation :generate_hruid, unless: :hruid, :on => :create

  attr_accessor :current_update_author
  before_validation :update_updated_by
  before_save :track_password_changes, if: :password_changed?

  before_validation :nil_if_blank

  before_validation(:on => :create) do 
  	#set id_soce
  	if attribute_present?(:id_soce)
  		set_id_soce_seq_value_to_max
  	else
  		self.id_soce = self.class.next_id_soce_seq_value
  	end
  end

  after_create :account_completer,unless: :is_from_legacy_gram1?
  after_update :account_completer


  #model validations

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, allow_nil: true
  validates :uuid, uniqueness: true
  validates :id_soce, presence: true, numericality: { only_integer: true }
  validates :enabled, :inclusion => {:in => [true, false]}
  validates :password, presence: true
  validates :hruid,  uniqueness: true
  validates :gapps_id,  uniqueness: true, allow_blank: true
	validates :gender, inclusion: {in: %w(male female)}, allow_blank: true
  validates :is_gadz, :inclusion => {:in => [true, false]}, allow_nil: true
  validates :buque_texte, format: { with: /\A[[:alpha:]0-9\'\-\s]*\z/}, allow_nil: true
  validates :gadz_fams, format: { with: /\A[0-9\(\)\!\-\s]*\z/}, allow_nil: true

  with_options unless: :is_from_legacy_gram1? do |not_legacy|
    not_legacy.validates :firstname, presence: true
    not_legacy.validates :lastname, presence: true
    not_legacy.validates :email, uniqueness: true, allow_nil: true
    not_legacy.validates :id_soce, uniqueness: true
  end



  # This enum is persisted as an integer in database
  # if you need to add new status, apend it at the end of the list or it will break mapping
  #
  # 0 : safe, there is no known problems on this account
  # 1 : watched, account may have problem and you should checkaudit comments and Jira for known issues
  # 2 : errors, account have problems but can still be used. You should check audit comments and Jira for known issues
  # 3 : broken, account have problems and can't be used anymore. You should check audit comments and Jira for known issues
  #
  # Doc concerning enums : http://api.rubyonrails.org/v4.1/classes/ActiveRecord/Enum.html
  enum audit_status: [:safe, :watched, :errors, :broken]
  scope :not_safe, -> { where.not(audit_status: MasterData::Account.audit_statuses[:safe]) }

  def self.next_id_soce_seq_value
  	result = self.connection.execute("SELECT nextval('id_soce_seq')")
  	result[0]['nextval']
  end


  def set_id_soce_seq_value_to_max
  	self.class.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, ["SELECT setval('id_soce_seq',(SELECT GREATEST((SELECT MAX(id_soce) FROM gram_accounts),(SELECT last_value FROM id_soce_seq),?)))",self.id_soce]))
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
    connection_alias.destroy
  end

  def add_new_alias alias_name
    unless self.alias.where(name: alias_name).any?
      new_alias = MasterData::Alias.create(name: alias_name, account: self)
    end
  end

  def update_aliases(aliases)
    if aliases.nil?
      return true
    else
      new_aliases_list = aliases.map{|a| a[:name]}
      current_aliases_list = self.alias.map(&:name)

      aliases_to_add = new_aliases_list - current_aliases_list
      aliases_to_remove = current_aliases_list - new_aliases_list

      GorgRabbitmqNotifier.batch do
        aliases_to_add.each { |a| self.add_new_alias(a) }
        aliases_to_remove.each { |a| MasterData::Alias.find_by(name: a).destroy }
      end

      return self.alias
    end
  end

  def remove_all_alias
    self.alias.destroy_all
  end

  def update_updated_by
    self.updated_by=current_update_author
  end

  def track_password_changes
    self.password_updated_at=DateTime.now
    self.password_updated_by=current_update_author
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


  protected

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

end
