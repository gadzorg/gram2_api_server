class Role < ApplicationRecord
  has_and_belongs_to_many :clients, join_table: :clients_roles

  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify

  # List all availables roles
  def self.list_availables
    [
      %i[gram_admin],
      %i[admin],
      %i[read],
      [:admin, MasterData::Account],
      [:read, MasterData::Account],
      [:password_hash_reader, MasterData::Account],
      [:admin, MasterData::Group],
      [:read, MasterData::Group],
      [:admin, MasterData::Role],
      [:read, MasterData::Role],
    ]
  end
end
