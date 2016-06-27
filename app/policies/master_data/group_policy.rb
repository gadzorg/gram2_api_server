class MasterData::GroupPolicy < BasePolicy
  attr_reader :client, :group

  def initialize(client, group)
    @client = client
    @group = group
  end

  def update?
    # client.admin? or not group.published?

  end

  def index?
    return false unless (client.has_role? :admin, MasterData::Group)
    return true
  end

end