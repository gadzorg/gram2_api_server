class Api::V2::RolesController < ApplicationController
  before_action :set_api_v2_role, only: [:show, :edit, :update, :destroy]

  #TODO : remove line bellow, it skips auth
  skip_before_action :verify_authenticity_token

  # GET /api/v2/roles
  # GET /api/v2/roles.json
  def index
    @api_v2_roles = MasterData::Role.all
  end

  # GET /api/v2/roles/1
  # GET /api/v2/roles/1.json
  def show
  end

  # GET /api/v2/roles/new
  def new
    @api_v2_role = MasterData::Role.new
  end

  # GET /api/v2/roles/1/edit
  def edit
  end

  # POST /api/v2/roles
  # POST /api/v2/roles.json
  def create
    @api_v2_role = MasterData::Role.new(api_v2_role_params)

    respond_to do |format|
      if @api_v2_role.save
        format.html { redirect_to @api_v2_role, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: :api_v2_roles }
      else
        format.html { render :new }
        format.json { render json: @api_v2_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v2/roles/1
  # PATCH/PUT /api/v2/roles/1.json
  def update
    respond_to do |format|
      if @api_v2_role.update(api_v2_role_params)
        format.html { redirect_to @api_v2_role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_v2_role }
      else
        format.html { render :edit }
        format.json { render json: @api_v2_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v2/roles/1
  # DELETE /api/v2/roles/1.json
  def destroy
    @api_v2_role.destroy
    respond_to do |format|
      format.html { redirect_to api_v2_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v2_role
      @api_v2_role = Api::V2::Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_v2_role_params
      params.require(:role).permit(:name, :application, :description)
    end
end
