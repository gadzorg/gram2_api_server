class Api::V2::AccountsController < ApplicationController
  before_action :set_api_v2_account, only: [:show, :edit, :update, :destroy]

    #TODO : remove line bellow, it skips auth
    skip_before_action :verify_authenticity_token

  # GET /api/v2/accounts
  # GET /api/v2/accounts.json
  def index
    @api_v2_accounts = MasterData::Account.all
  end

  # GET /api/v2/accounts/1
  # GET /api/v2/accounts/1.json
  def show
  end

  # GET /api/v2/accounts/new
  def new
    @api_v2_account = MasterData::Account.new
  end

  # GET /api/v2/accounts/1/edit
  def edit
  end

  # POST /api/v2/accounts
  # POST /api/v2/accounts.json
  def create
    @api_v2_account = MasterData::Account.new(api_v2_account_params)

    respond_to do |format|
      if @api_v2_account.save
        format.html { redirect_to @api_v2_account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: :api_v2_accounts }
      else
        format.html { render :new }
        format.json { render json: @api_v2_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v2/accounts/1
  # PATCH/PUT /api/v2/accounts/1.json
  def update
    respond_to do |format|
      if @api_v2_account.update(api_v2_account_params)
        format.html { redirect_to @api_v2_account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: :api_v2_account }
      else
        format.html { render :edit }
        format.json { render json: @api_v2_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v2/accounts/1
  # DELETE /api/v2/accounts/1.json
  def destroy
    @api_v2_account.destroy
    respond_to do |format|
      format.html { redirect_to api_v2_accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #########################################################
  #  Groups management
  #########################################################
  def index_groups
    account = MasterData::Account.find(params[:account_id])
    @groups = account.groups
  end

  def show_groups
    account = MasterData::Account.find(params[:account_id])
    if account.groups.exists?(params[:group_id])
     @group = account.groups.find(params[:group_id])
   else
    render json: { error: "Group not found" }, status: :not_found
    end
  end

  def add_to_group
    account = MasterData::Account.find(params[:account_id])
    group_id = params[:id]
    @group = MasterData::Group.find(group_id)
    @groups = account.groups


    respond_to do |format|
      if account.add_to_group @group
        format.html { redirect_to api_v2_account_groups(account), notice: 'Group was successfully added to the Account.' }
        format.json { render :index_groups, status: :created, location: :api_v2_account_index_groups }
      else
        format.html { render :new }
        format.json { render json: account.errors, status: :unprocessable_entity }
      end
    end

  end

  def remove_from_group
    account = MasterData::Account.find(params[:account_id])
    group = account.groups.find(params[:group_id])

    respond_to do |format|
      if account.remove_from_group group
        format.html { redirect_to api_v2_accounts_url, notice: 'Group was successfully revomed from this account.' }
        format.json { head :no_content }
      end
    end

  end

  #########################################################
  #  Roles management
  #########################################################

  def index_roles
    account = MasterData::Account.find(params[:account_id])
    @roles = account.roles
    @api_v2_roles = @roles
  end

  def show_roles
    account = MasterData::Account.find(params[:account_id])
    if account.roles.exists?(params[:role_id])
      @role = account.roles.find(params[:role_id])
      respond_to do |format|
        format.json {render :show_roles, location: :api_v2_roles}
      end
      
    else
      render json: { error: "Role not found" }, status: :not_found
    end
  end

  def add_role
    account = MasterData::Account.find(params[:account_id])
    role_id = params[:id]
    @role = MasterData::Role.find(role_id)
    @roles = account.roles


    respond_to do |format|
      if account.add_role @role
        format.html { redirect_to api_v2_account_roles(account), notice: 'Role was successfully added to the Account.' }
        format.json { render :index, status: :created, location: :api_v2_roles }
      else
        format.html { render :new }
        format.json { render json: account.errors, status: :unprocessable_entity }
      end
    end

  end

  def revoke_role
    account = MasterData::Account.find(params[:account_id])
    role = account.roles.find(params[:role_id])

    respond_to do |format|
      if account.revoke_role role
        format.html { redirect_to api_v2_roles_url, notice: 'Role was successfully revomed from this account.' }
        format.json { head :no_content }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v2_account
      @api_v2_account = MasterData::Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_v2_account_params
      params.require(:account).permit(:uuid, :hruid, :id_soce, :enabled, :password, :lastname, :firstname, :birthname, :birth_firstname, :email, :gapps_email, :password, :birthdate, :deathdate, :gender, :is_gadz, :is_student, :school_id, :is_alumni, :date_entree_ecole, :date_sortie_ecole, :ecole_entree, :buque_texte, :buque_zaloeil, :gadz_fams, :gadz_fams_zaloeil, :gadz_proms_principale, :gadz_proms_secondaire, :avatar_url, :description)
    end
  end
