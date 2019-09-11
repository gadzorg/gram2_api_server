module ApiHelper
  def auth_headers
    { "X-User-Name" => "client", "X-User-Token" => "secrettoken" }
  end
  alias html_auth_headers auth_headers

  def json_headers
    { "Accept" => "application/json" }
  end

  def json_auth_headers
    auth_headers.merge(json_headers)
  end

  def json_body
    @json_body ||= JSON.parse(response.body)
  end
end
