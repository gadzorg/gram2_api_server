class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  # Auth by token for simple_token_authentification
  acts_as_token_authentication_handler_for Client
  # Dirty hack for every dirty gem with hard coded current_user
  alias_method :current_user, :current_client

  # Authorizations
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :client_not_authorized

  private

  def client_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    # TODO : remove policy name in exception
    render status: :forbidden, json: {message: "Forbidden. #{policy_name}.#{exception.query}"}
  end
end
