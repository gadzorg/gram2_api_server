class MasterData::Account < MasterData::Base
	has_and_belongs_to_many :groups
	has_and_belongs_to_many :roles


	def add_to_group group
		#check if account already in tihs group
		self.groups << group unless self.groups.exists?(group.id)
	end

	def remove_from_group group
		self.groups.delete group
	end

	def add_role role
		#check if account already in tihs group
		self.roles << role unless self.roles.exists?(role.id)
	end

	def revoke_role role
		self.roles.delete role
	end

end
