class Api::V2::AccountsController < Api::V2::BaseController
  before_action :set_api_v2_account, only: [:show, :edit, :update, :destroy, :index_groups, :show_groups, :add_to_group, :remove_from_group , :index_roles, :show_roles, :add_role, :revoke_role]
  before_action :get_new_aliases, only: [:edit, :update, :create]
  before_action :set_group_parent, only: [:index]
  before_action :set_account_parent, only: [:remove_from_group, :add_to_group, :add_role, :revoke_role]

  # GET /api/v2/accounts
  # GET /api/v2/accounts.json
  def index
    filter = params.permit(:hruid, :id_soce, :enabled, :lastname, :firstname, :birthname, :birth_firstname, :email, :gapps_id, :password, :birthdate, :deathdate, :gender, :is_gadz, :is_student, :school_id, :is_alumni, :date_entree_ecole, :date_sortie_ecole, :ecole_entree, :buque_texte, :buque_zaloeil, :gadz_fams, :gadz_fams_zaloeil, :gadz_proms_principale, :gadz_proms_secondaire, :description, :alias)
    if @group
      @accounts = @group.accounts
    else

      if params[:exact_search] == "false"
        @accounts = MasterData::Account.like(filter).includes(:groups, :alias, :roles)
      else
        @accounts = MasterData::Account.where(filter).includes(:groups, :alias, :roles)
      end
    end
    authorize @accounts, :index?
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @accounts}
    end
  end

  # GET /api/v2/accounts/1
  # GET /api/v2/accounts/1.json
  def show
    authorize @account, :index?
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @account, show_password_hash: show_password_hash?}
    end
  end

  # GET /api/v2/accounts/new
  def new
    @account = MasterData::Account.new
    authorize @account, :create?
  end

  # GET /api/v2/accounts/1/edit
  def edit
    authorize @account, :edit?
  end

  # POST /api/v2/accounts
  # POST /api/v2/accounts.json
  def create
    @account = MasterData::Account.new(api_v2_account_params)
    authorize @account, :create?

    respond_to do |format|
      # keep @account.save at the end of the condition bellow to ensure the right object is returned during rendering
      if @account.update_aliases(@aliases) && @account.save
        format.html { render :show, notice: 'Account was successfully created.' }
        format.json { render json: @account, status: :created, location: :api_v2_accounts }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v2/accounts/1
  # PATCH/PUT /api/v2/accounts/1.json
  def update
    authorize @account, :edit?
    respond_to do |format|
      # keep @account.save at the end of the condition bellow to ensure the right object is returned during rendering
      if @account.update_aliases(@aliases) && @account.update(api_v2_account_params)
        format.html { render :show,@account, notice: 'Account was successfully updated.' }
        format.json { render json: @account, status: :ok, location: :api_v2_account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v2/accounts/1
  # DELETE /api/v2/accounts/1.json
  def destroy
    @account.destroy
    authorize @account, :destroy?
    respond_to do |format|
      format.html { redirect_to api_v2_accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #########################################################
  #  ID_SOCE reservation
  #########################################################
  # POST /api/v2/accounts/reserve_next_id_soce.json
  def reserve_next_id_soce
    @account = MasterData::Account.new
    authorize @account, :create?
    @id_soce = MasterData::Account.next_id_soce_seq_value
    respond_to do |format|
      format.json { render json: {id_soce: @id_soce}, status: :created}
    end
  end
  #########################################################
  #  Groups management
  #########################################################
    def add_to_group
    group_uuid = params[:group_uuid]
    @group = MasterData::Group.find_by(uuid: group_uuid)
    @groups = @account.groups
    authorize @group, :edit?

    respond_to do |format|
      if @account.add_to_group @group
        format.html { redirect_to api_v2_account_groups(@account), notice: 'Group was successfully added to the Account.' }
        format.json { render json: @groups, status: :created }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end

  end

  def remove_from_group
    # @account = MasterData::Account.find_by(uuid: params[:account_uuid])
    # puts "=========ef=ef=efe=f=efe=fe=fe=f"
    # puts @account
    group = @account.groups.find_by(uuid: params[:group_uuid])
    authorize group, :edit?
    respond_to do |format|
      if @account.remove_from_group group
        format.html { redirect_to api_v2_accounts_url, notice: 'Group was successfully revomed from this account.' }
        format.json { head :no_content }
      end
    end

  end

  #########################################################
  #  Roles management
  #########################################################
  def add_role
    role_uuid = params[:role_uuid]
    @role = MasterData::Role.find_by(uuid: role_uuid)
    @roles = @account.roles
    authorize @role, :edit?

    respond_to do |format|
      if @account.add_role @role
        format.html { redirect_to api_v2_account_roles(@account), notice: 'Role was successfully added to the Account.' }
        format.json { render json: @roles, status: :created }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end

  end

  def revoke_role
    role = @account.roles.find_by(uuid: params[:role_uuid])
    authorize role, :edit?

    respond_to do |format|
      if @account.revoke_role role
        format.html { redirect_to api_v2_roles_url, notice: 'Role was successfully revomed from this account.' }
        format.json { head :no_content }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v2_account
      # @account = MasterData::Account.find(params[:id])
      @account = MasterData::Account.find_by(uuid: params[:uuid])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_v2_account_params
      params.require(:account).permit(:uuid, :hruid, :id_soce, :enabled, :password, :lastname, :firstname, :birthname, :birth_firstname, :email, :gapps_id, :password, :birthdate, :deathdate, :gender, :is_gadz, :is_student, :school_id, :is_alumni, :date_entree_ecole, :date_sortie_ecole, :ecole_entree, :buque_texte, :buque_zaloeil, :gadz_fams, :gadz_fams_zaloeil, :gadz_proms_principale, :gadz_proms_secondaire, :avatar_url, :description)
    end

    def  show_password_hash?
      params[:show_password_hash] == "true" ? true : false
    end

    def get_new_aliases
      @aliases = params[:alias]
    end

  end
