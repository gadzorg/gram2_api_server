class MasterData::RoleSerializer < BaseSerializer
  attributes :id, :name, :application, :description
  attributes :url

  def url
  	api_v2_role_path(object)
  end
end
