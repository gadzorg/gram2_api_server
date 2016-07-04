class MasterData::Role < MasterData::Base
	#relations
	has_and_belongs_to_many :accounts

	#callbacks
	after_save :request_ldap_sync

	#model validations
	validates :name, :application, :description, presence: true
	validates :name, uniqueness: true

	def request_ldap_sync
		message = LdapDaemon.new
		message.request_role_update(self)
	end
end
