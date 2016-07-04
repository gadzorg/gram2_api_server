class MasterData::Group < MasterData::Base
  #relations
  has_and_belongs_to_many :accounts

  #callbacks
  before_validation :generate_uuid_if_empty
  after_save :request_ldap_sync

  #model validations
  validates :name, presence: true
  validates :description, presence: true
  validates :uuid, uniqueness: true
  validates :short_name, uniqueness: true, presence: true

  #roles
  resourcify

  def generate_uuid_if_empty
    self.uuid ||= self.generate_uuid
  end

  def generate_uuid
    self.guid = loop do
      random_uuid = SecureRandom.uuid
      break random_uuid unless MasterData::Group.exists?(uuid: random_uuid)
    end
  end

  def request_ldap_sync ldap_daemon = LdapDaemon.new
    ldap_daemon.request_group_update(self)
  end
end
