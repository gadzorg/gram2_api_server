class MasterData::Group < MasterData::Base
  include GorgRabbitmqNotifier::ActiveRecordExtension
  rabbitmq_resource_type :group
  rabbitmq_id :uuid

  #relations
  has_and_belongs_to_many :accounts,
                          after_add: :capture_add_association,
                          after_remove: :capture_del_association

  #callbacks
  before_validation :generate_uuid_if_empty

  #model validations
  validates :name, presence: true
  validates :description, presence: true
  validates :uuid, uniqueness: true
  validates :short_name, uniqueness: true, presence: true

  #roles
  resourcify
end
