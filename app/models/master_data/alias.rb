class MasterData::Alias < MasterData::Base
  #relations
  belongs_to :account

  #callback
  after_save :sync_attached_account_to_ldap

  #model validation
  validates :name, presence: true, uniqueness: true

  def sync_attached_account_to_ldap
    request_account_ldap_sync(LdapDaemon.new, self.account) if self.account.present?
  end
end

