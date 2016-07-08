class Api::V2::RolesController < Api::V2::BaseController
  before_action :set_api_v2_role, only: [:show, :edit, :update, :destroy]
  before_action :set_account_parent, only: [:index]


  # GET /api/v2/roles
  # GET /api/v2/roles.json
  def index
    if @account
      @roles = @account.roles
    else
      @roles = MasterData::Role.all
    end
    authorize @roles, :index?
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @roles}
    end
  end

  # GET /api/v2/roles/1
  # GET /api/v2/roles/1.json
  def show
    authorize @role, :index?
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @role}
    end
  end

  # GET /api/v2/roles/new
  def new
    @role = MasterData::Role.new
    authorize @role, :create?
  end

  # GET /api/v2/roles/1/edit
  def edit
    authorize @role, :edit?
  end

  # POST /api/v2/roles
  # POST /api/v2/roles.json
  def create
    @role = MasterData::Role.new(api_v2_role_params)
    authorize @role, :create?

    respond_to do |format|
      if @role.save
        format.html { render :show, notice: 'Role was successfully created.' }
        format.json { render json: @role, status: :created }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v2/roles/1
  # PATCH/PUT /api/v2/roles/1.json
  def update
    authorize @role, :edit?
    respond_to do |format|
      if @role.update(api_v2_role_params)
        format.html { render :show, notice: 'Role was successfully updated.' }
        format.json { render json: @role, status: :ok}
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v2/roles/1
  # DELETE /api/v2/roles/1.json
  def destroy
    @role.destroy
    authorize @role, :destroy?
    respond_to do |format|
      format.html { redirect_to api_v2_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v2_role
      @role = MasterData::Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_v2_role_params
      params.require(:role).permit(:name, :application, :description)
    end
end
