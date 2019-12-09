class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
    authorize @clients, :index?
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    authorize @client, :index?
    @roles = Role.list_availables
  end

  # GET /clients/new
  def new
    @client = Client.new
    authorize @client, :create?
  end

  # GET /clients/1/edit
  def edit
    authorize @client, :edit?
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    authorize @client, :create?
    respond_to do |format|
      if @client.save
        format.html do
          redirect_to @client, notice: "Client was successfully created."
        end
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json do
          render json: @client.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    authorize @client, :edit?
    respond_to do |format|
      if @client.update(client_params)
        format.html do
          redirect_to @client, notice: "Client was successfully updated."
        end
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json do
          render json: @client.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    authorize @client, :destroy?
    @client.destroy
    respond_to do |format|
      format.html do
        redirect_to clients_url, notice: "Client was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  def add_role
    client = Client.find(params[:client_id])
    authorize client, :edit?
    role_name = params[:role_name]
    ressource = params[:ressource]
    ressource = ressource.constantize unless ressource.nil?
    client.add_role(role_name.to_sym, ressource)
    redirect_to client_url(client), notice: "Role ajouté"
  end

  def remove_role
    client = Client.find(params[:client_id])
    authorize client, :edit?
    role_name = params[:role_name]
    ressource = params[:ressource]
    ressource = ressource.constantize unless ressource.nil?
    client.remove_role(role_name.to_sym, ressource)
    redirect_to client_url(client), notice: "Role retiré"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(
      :name,
      :password,
      :description,
      :active,
      :email,
      :authentication_token,
    )
  end
end
