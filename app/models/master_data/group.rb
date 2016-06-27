class MasterData::Group < MasterData::Base
  #relations
  has_and_belongs_to_many :accounts

  #callbacks
  before_validation :generate_guid_if_empty
  
  #model validations
  validates :name, presence: true
  validates :description, presence: true
  validates :guid, uniqueness: true
  validates :short_name, uniqueness: true, presence: true

  #roles
  resourcify


  def generate_guid_if_empty
    self.guid ||= self.generate_guid
  end

  def generate_guid
    self.guid = loop do
      random_guid = SecureRandom.uuid
      break random_guid unless MasterData::Group.exists?(guid: random_guid)
    end
  end
end
