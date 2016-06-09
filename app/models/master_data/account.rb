class MasterData::Account < MasterData::Base
	has_and_belongs_to_many :groups
	has_and_belongs_to_many :roles
end
