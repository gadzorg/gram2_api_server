class ApplicationPolicy < BasePolicy
  attr_reader :client, :record

  def initialize(client, record)
    @client = client
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(client, record.class)
  end

  class Scope
    attr_reader :client, :scope

    def initialize(client, scope)
      @client = client
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
