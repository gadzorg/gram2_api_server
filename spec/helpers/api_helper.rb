module ApiHelper
  def auth_headers
    { "X-User-Name" => "client", "X-User-Token" => "secrettoken" }
  end
  alias standard_html_headers auth_headers

  def standard_headers
    auth_headers.merge("Accept" => "application/json")
  end

  def json_body
    @json_body ||= JSON.parse(response.body)
  end
end
