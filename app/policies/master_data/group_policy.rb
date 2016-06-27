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
    true
  end

  def pundit_user
    current_client
    puts "hello"
  end
end