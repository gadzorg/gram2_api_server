class ClientPolicy < BasePolicy
  attr_reader :client, :record

  def initialize(client, record)
    @client = client
    @record = record
  end

  def index?
    has_scope?(client, :gram_admin)
  end

  def create?
    has_scope?(client, :gram_admin)
  end

  def edit?
    has_scope?(client, :gram_admin)
  end

  def destroy?
    has_scope?(client, :gram_admin)
  end
end
