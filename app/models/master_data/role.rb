class MasterData::Role < MasterData::Base

  resourcify
  
	#relations
	has_and_belongs_to_many :accounts

	#callbacks
	after_save :request_ldap_sync

	#model validations
	validates :name, :application, :description, presence: true
	validates :name, uniqueness: true

	def request_ldap_sync ldap_daemon = LdapDaemon.new
		ldap_daemon.request_role_update(self)
	end
end
