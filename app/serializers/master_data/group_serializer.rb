class MasterData::GroupSerializer < BaseSerializer
  attributes :uuid, :short_name, :name, :description
  attributes :url

  def url
  	api_v2_group_path(object)
  end
end
 