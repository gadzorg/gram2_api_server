class Api::V2::GroupsController < Api::V2::BaseController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :set_account_parent, only: [:index]

  # GET /groups
  # GET /groups.json
  def index
    if @account
      @groups = @account.groups
    else
      @groups = MasterData::Group.all
    end
    authorize @groups, :index?
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @groups}
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    authorize @group, :index?
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @group}
    end
  end

  # GET /groups/new
  def new
    @group = MasterData::Group.new
    authorize @group, :create?
  end

  # GET /groups/1/edit
  def edit
    authorize @group, :edit?
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = MasterData::Group.new(group_params)
    authorize @group, :create?

    respond_to do |format|
      if @group.save
        format.html { render :show, notice: 'MasterData::Group was successfully created.' }
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
    authorize @group, :edit?
    respond_to do |format|
      if @group.update(group_params)
        format.html { render :show, notice: 'MasterData::Group was successfully updated.' }
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
    authorize @group, :destroy?
    @group.destroy
    respond_to do |format|
      format.html { redirect_to api_v2_groups_url, notice: 'MasterData::Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = MasterData::Group.where(id: params[:id]).first || MasterData::Group.where(uuid: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:guid, :name, :short_name, :description)
    end
end
