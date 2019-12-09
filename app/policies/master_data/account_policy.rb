class MasterData::AccountPolicy < BasePolicy
  def edit?
    scopes = [%i[admin], [:admin, MasterData::Account]]
    has_at_least_one_scope(client, scopes)
  end

  def index?
    scopes = [
      %i[admin],
      %i[read],
      [:admin, MasterData::Account],
      [:read, MasterData::Account],
    ]
    has_at_least_one_scope(client, scopes)
  end

  def destroy?
    scopes = [%i[admin], [:admin, MasterData::Account]]
    has_at_least_one_scope(client, scopes)
  end

  def create?
    scopes = [%i[admin], [:admin, MasterData::Account]]
    has_at_least_one_scope(client, scopes)
  end

  def show_password_hash?
    scopes = [[:password_hash_reader, MasterData::Account]]
    has_at_least_one_scope(client, scopes)
  end
end
