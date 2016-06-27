class Api::V2::GroupsController < Api::V2::BaseController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  #before_action :authenticate_client!
  # before_action :current_user

  # GET /groups
  # GET /groups.json
  def index
    @groups = MasterData::Group.all
    authorize @groups, :index?
    respond_to do |format|
      format.json {render json: @groups}
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    respond_to do |format|
      format.json {render json: @group}
    end
  end

  # GET /groups/new
  def new
    @group = MasterData::Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = MasterData::Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'MasterData::Group was successfully created.' }
        format.json { render json: @group, status: :created}
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'MasterData::Group was successfully updated.' }
        format.json { render json: @group, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to api_v2_groups_url, notice: 'MasterData::Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #########################################################
  #  Accounts management
  #########################################################

  def index_accounts
    group = MasterData::Group.find(params[:group_id])
    @accounts = group.accounts
    respond_to do |format|
      format.json {render json: @accounts}
    end

  end

  def show_accounts
    group = MasterData::Group.find(params[:group_id])
    if group.accounts.exists?(params[:account_id])
     @account = group.accounts.find(params[:account_id])
      respond_to do |format|
        format.json {render json: @account}
      end
   else
    render json: { error: "Acount not found" }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = MasterData::Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:guid, :name, :short_name, :description)
    end
end
