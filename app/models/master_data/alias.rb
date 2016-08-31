class MasterData::Alias < MasterData::Base
  #relations
  belongs_to :account

  #callback
  #after_save :sync_attached_account_to_ldap

  #model validation
  validates :name, presence: true, uniqueness: true

  # def sync_attached_account_to_ldap

  #   self.account.request_account_ldap_sync(LdapDaemon.new, self.account) if self.account.present?
  # end

  def rabbitmq_id
    name
  end

end

