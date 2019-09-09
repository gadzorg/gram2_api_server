class MasterData::RolePolicy < BasePolicy
  def edit?
    scopes = [%i[admin], [:admin, MasterData::Role]]
    has_at_least_one_scope(client, scopes)
  end

  def index?
    scopes = [
      %i[admin],
      %i[read],
      [:admin, MasterData::Role],
      [:read, MasterData::Role],
    ]
    has_at_least_one_scope(client, scopes)
  end

  def destroy?
    scopes = [%i[admin], [:admin, MasterData::Role]]
    has_at_least_one_scope(client, scopes)
  end

  def create?
    scopes = [%i[admin], [:admin, MasterData::Role]]
    has_at_least_one_scope(client, scopes)
  end
end
