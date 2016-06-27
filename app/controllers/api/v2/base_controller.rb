class Api::V2::BaseController < ApplicationController
  #TODO : remove line bellow, it skips auth
  skip_before_action :verify_authenticity_token
end