class MasterData::GroupPolicy < BasePolicy
  def edit?
    scopes = [
        [:admin],
        [:admin, MasterData::Group]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def index?
    scopes = [
        [:admin],
        [:read],
        [:admin, MasterData::Group],
        [:read, MasterData::Group]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def destroy?
    scopes = [
        [:admin],
        [:admin, MasterData::Group]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def create?
    scopes = [
        [:admin],
        [:admin, MasterData::Group]
    ]
    has_at_least_one_scope(client, scopes)
  end

end