class MasterData::GroupSerializer < BaseSerializer
  attributes :id, :guid, :short_name, :name, :description
  attributes :url

  def url
  	api_v2_group_path(object)
  end
end
 