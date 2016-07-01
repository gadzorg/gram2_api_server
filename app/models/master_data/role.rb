class MasterData::Role < MasterData::Base

  resourcify
  
	#relations
	has_and_belongs_to_many :accounts

	#model validations
	validates :name, :application, :description, presence: true
	validates :name, uniqueness: true
end
