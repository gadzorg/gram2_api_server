class MasterData::RolePolicy < ApplicationPolicy

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