class MasterData::AccountPolicy < ApplicationPolicy

  def edit?
    scopes = [
        [:admin],
        [:admin, MasterData::Account]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def index?
    scopes = [
        [:admin],
        [:read],
        [:admin, MasterData::Account],
        [:read, MasterData::Account]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def destroy?
    scopes = [
        [:admin],
        [:admin, MasterData::Account]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def create?
    scopes = [
        [:admin],
        [:admin, MasterData::Account]
    ]
    has_at_least_one_scope(client, scopes)
  end

  def show_password_hash?
    scopes = [
        [:password_hash_reader, MasterData::Account]
    ]
    has_at_least_one_scope(client, scopes)
  end

end