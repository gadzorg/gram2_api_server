class MasterData::RolePolicy < BasePolicy
  attr_reader :client, :role

  def initialize(client, role)
    @client = client
    @role = role
  end

  def edit?
    scopes = [
        [:admin],
        [:admin, MasterData::Role]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def index?
    scopes = [
        [:admin],
        [:read],
        [:admin, MasterData::Role],
        [:read, MasterData::Role]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def destroy?
    scopes = [
        [:admin],
        [:admin, MasterData::Role]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def create?
    scopes = [
        [:admin],
        [:admin, MasterData::Role]
    ]
    has_at_least_one_scope(client, scopes)
  end

end