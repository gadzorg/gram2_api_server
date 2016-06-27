class Clients::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
    puts "=============nes sess"
    puts resource
    puts resource.name
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  prepend_before_filter :require_no_authentication, :only => [:create ]
  # include Devise::Controllers::InternalHelpers

  #before_filter :ensure_params_exist

  skip_before_action :verify_authenticity_token


  respond_to :json

  def create
    #build_resource
    # TODO : clean params and use permit
    resource = Client.find_by(name: params[:name])
    puts "======================="
    puts resource
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
      sign_in("client", resource)
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.name, :email=>resource.email}
      return
    end

  end

  # def create
  #   build_resource
  #   resource = Client.find_for_database_authentication(:login=>params[:client_login][:login])
  #   return invalid_login_attempt unless resource
  #
  #   if resource.valid_password?(params[:client_login][:password])
  #     sign_in("user", resource)
  #     render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
  #     return
  #   end
  #   invalid_login_attempt
  # end
  #
  def destroy
    sign_out(resource_name)
  end
  #
  protected
  # def ensure_params_exist
  #   return unless params[:client_login].blank?
  #   render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  # end
  #
  def invalid_login_attempt
     warden.custom_failure!
     render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end
