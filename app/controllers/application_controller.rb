class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  # Auth by token for simple_token_authentification
  acts_as_token_authentication_handler_for Client

  # Authorizations
  include Pundit

end
