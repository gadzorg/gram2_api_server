class MasterData::Role < MasterData::Base
  resourcify

  def rabbitmq_id
    { name: name, application: application, description: description }
  end

  #relations
  has_and_belongs_to_many :accounts

  #callbacks
  before_validation :generate_uuid_if_empty

  #model validations
  validates :name, :application, :description, presence: true
  validates :name, uniqueness: true
end
