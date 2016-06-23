class MasterData::Account < MasterData::Base

	require "hruid_service"

  #relations
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :roles

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
  
  #model validations
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :uuid, uniqueness: true
  validates :id_soce, uniqueness: true
  validates :enabled, :inclusion => {:in => [true, false]}
  validates :password, presence: true
  validates :hruid,  uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
	validates :gender, inclusion: {in: %w(male female)}, allow_nil: true
  validates :is_gadz, :inclusion => {:in => [true, false]}
  validates :buque_texte, format: { with: /\A[a-zA-Z0-9\'\-\s]\z/}, allow_nil: true
  validates :gadz_fams, format: { with: /\A[0-9\(\)\!\-\s]\z/}, allow_nil: true

	
  def generate_uuid_if_empty
  	self.uuid ||= self.generate_uuid
  end

  def generate_uuid
  	self.uuid = loop do
  		random_uuid = SecureRandom.uuid
  		break random_uuid unless MasterData::Account.exists?(uuid: random_uuid)
  	end
  end
  
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
