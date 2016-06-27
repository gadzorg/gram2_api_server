class Api::V2::BaseController < ApplicationController
  #TODO : remove line bellow, it skips auth
  skip_before_action :verify_authenticity_token

  alias_method :current_user, :current_client

  before_action :authenticate_client!
  before_filter :require_login

  private

  def require_login
    puts "==============================================="
    puts current_client.name
    unless current_client
      render status: :forbidden, json: {message: "Forbidden. Please login"}
    end
  end
end