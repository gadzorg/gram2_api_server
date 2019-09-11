class Clients::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token

  respond_to :json

  def after_sign_out_path_for(resource)
    new_client_session_path
  end

  # TODO: get rid of this custom behavior :
  # API clients should use token instead
  def create
    # default behavior for html requests
    return super if request.format.html?

    # handle json authentications
    resource = Client.find_by(name: client_params[:name])

    return invalid_login_attempt unless resource

    if resource.valid_password?(client_params[:password])
      sign_in("client", resource)

      @client = resource
      render "clients/show", status: :created
    else
      invalid_login_attempt
    end
  end

  protected

  def client_params
    params.require(:client).permit(:name, :password)
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {
             success: false, message: "Error with your login or password"
           },
           status: 401
  end
end
