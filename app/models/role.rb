class Role < ActiveRecord::Base
  has_and_belongs_to_many :clients, :join_table => :clients_roles

  belongs_to :resource,
             :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  # List all availables roles
  def self.list_availables
    [
        [:gram_admin],
        [:admin],
        [:read],
        [:admin, MasterData::Account],
        [:read, MasterData::Account],
        [:password_hash_reader, MasterData::Account],
        [:admin, MasterData::Group],
        [:read, MasterData::Group],
        [:admin, MasterData::Role],
        [:read, MasterData::Role]
    ]
  end

end
