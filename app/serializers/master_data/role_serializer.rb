class MasterData::RoleSerializer < BaseSerializer
  attributes :uuid, :name, :application, :description
  attributes :url

  def url
    api_v2_role_path(object)
  end
end
