json.array!(@groups) do |group|
  json.extract! group, :id, :guid, :name, :description
  json.url  api_v2_group_url(group, format: :json)
end
