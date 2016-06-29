json.array!(@clients) do |client|
  json.extract! client, :id, :name, :password, :description, :active, :email, :authentication_token
  json.url client_url(client, format: :json)
end
