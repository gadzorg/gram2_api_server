class Api::V2::BaseController < ApplicationController
  #TODO : remove line bellow, it skips auth
  skip_before_action :verify_authenticity_token

  before_action :authenticate_client!
  before_filter :require_login

  # check if authorize is called for every action
  after_action :verify_authorized

  #To send context to serializer. Used to manage fields' filter with special ACL
  serialization_scope :view_context

  private

  def set_account_parent
    @account = MasterData::Account.where(id: params[:account_id]).first
  end

  def set_group_parent
    @group = MasterData::Group.where(id: params[:group_id]).first
  end

  def require_login
    # TODO : remove lines bellow
    puts "==============================================="
    puts current_client.name
    unless current_client
      render status: :unauthorized, json: {message: "401 Unauthorized"}
    end
  end
end