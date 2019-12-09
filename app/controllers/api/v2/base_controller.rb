class Api::V2::BaseController < ApplicationController
  #TODO : remove line bellow, it skips auth
  skip_before_action :verify_authenticity_token

  before_action :authenticate_client!
  before_action :require_login

  # check if authorize is called for every action
  after_action :verify_authorized

  # To send context to serializer. Used to manage fields' filter with special ACL
  serialization_scope :view_context

  private

  def set_account_parent
    @account = MasterData::Account.find_by(uuid: params[:account_uuid])
  end

  def set_group_parent
    @group = MasterData::Group.find_by(uuid: params[:group_uuid])
  end

  def require_login
    unless current_client
      render status: :unauthorized, json: { message: "401 Unauthorized" }
    end
  end
end
