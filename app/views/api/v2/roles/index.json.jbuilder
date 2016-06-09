json.array!(@api_v2_roles) do |api_v2_role|
  json.extract! api_v2_role, :id, :name, :application, :description
  json.url api_v2_role_url(api_v2_role, format: :json)
end
