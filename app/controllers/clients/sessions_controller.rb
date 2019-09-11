class Clients::SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: %i[create]

  skip_before_action :verify_authenticity_token

  respond_to :json

  def create
    #build_resource
    # TODO : clean params and use permit
    resource = Client.find_by(name: params[:client][:name])

    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:client][:password])
      sign_in("client", resource)
      redirect_to root_path
    else
      invalid_login_attempt
    end
  end

  def destroy
    sign_out(resource_name)
  end

  protected

  def invalid_login_attempt
    warden.custom_failure!
    render json: {
             success: false, message: "Error with your login or password"
           },
           status: 401
  end
end
