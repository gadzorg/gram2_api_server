# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V2::AccountsControllers", type: :request do
  setup { create(:client, :api_client) }

  describe "without headers" do
    it "does not return a 200" do
      get api_v2_accounts_path
      expect(response).to_not have_http_status(200)
    end
  end

  describe "GET /api/v2/accounts index" do
    let!(:accounts) { create_list(:master_data_account, 2) }

    describe "accept json" do
      let(:perform) { get api_v2_accounts_path, headers: json_auth_headers }

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")
      end

      it "list accounts" do
        perform

        expect(response.parsed_body.length).to eq(2)
        expect(response.parsed_body[0]["uuid"]).to eq(accounts[0].uuid)
      end

      it "filter" do
        get api_v2_accounts_path(email: accounts[0].email),
            headers: json_auth_headers

        expect(response.parsed_body.length).to eq(1)
        expect(response.parsed_body[0]["uuid"]).to eq(accounts[0].uuid)
      end

      it "filter, exact search" do
        get api_v2_accounts_path(
              email: accounts[0].email[0..-2], exact_search: "false",
            ),
            headers: json_auth_headers

        expect(response.parsed_body.length).to eq(1)
        expect(response.parsed_body[0]["uuid"]).to eq(accounts[0].uuid)
      end

      it "with group parent" do
        group = create(:master_data_group)
        account = create(:master_data_account, groups: [group])

        get api_v2_accounts_path(group_uuid: group.uuid),
            headers: json_auth_headers

        expect(response.parsed_body.length).to eq(1)
        expect(response.parsed_body[0]["uuid"]).to eq(account.uuid)
      end
    end

    describe "accept html" do
      let(:perform) do
        get api_v2_accounts_path(format: :html), headers: html_auth_headers
      end

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to match("text/html")
      end

      it "list accounts" do
        perform

        expect(response.body).to include("<th>Lastname</th>")

        accounts.each do |account|
          expect(response.body).to include("<td>#{account.lastname}</td>")
        end
      end
    end
  end

  describe "GET /api/v2/accounts/:uuid" do
    subject { create(:master_data_account) }

    describe "accept json" do
      it "shows the account" do
        get api_v2_account_path(uuid: subject.uuid), headers: json_auth_headers

        expect(response).to have_http_status(200)
        expect(response.parsed_body["uuid"]).to eq(subject.uuid)
        expect(response.parsed_body["email"]).to eq(subject.email)
      end

      it "returns a 404 for an account not found" do
        get api_v2_account_path(uuid: "notfound"), headers: json_auth_headers

        expect(response).to have_http_status(404)
      end
    end

    describe "accept html" do
      it "shows the account" do
        get api_v2_account_path(uuid: subject.uuid, format: :html),
            headers: html_auth_headers

        expect(response).to have_http_status(200)
        expect(response.body).to include(subject.uuid)
        expect(response.body).to include(subject.email)
      end
    end
  end

  describe "GET /api/v2/accounts/new" do
    it "shows the form account" do
      get new_api_v2_account_path(format: :html), headers: html_auth_headers

      expect(response).to have_http_status(200)
      expect(response.body).to include("<form")
    end
  end

  describe "GET /api/v2/accounts/:uuid/edit" do
    subject { create(:master_data_account) }

    it "shows the form account" do
      get edit_api_v2_account_path(uuid: subject.uuid, format: :html),
          headers: html_auth_headers

      expect(response).to have_http_status(200)
      expect(response.body).to include("<form")
      expect(response.body).to include(subject.uuid)
      expect(response.body).to include(subject.email)
    end
  end

  describe "POST /api/v2/accounts" do
    subject { attributes_for(:master_data_account).except(:uuid) }

    describe "accept json" do
      it "create an account" do
        post api_v2_accounts_path,
             params: { account: subject }, headers: json_auth_headers

        expect(response).to have_http_status(:created)
        expect(response.parsed_body["email"]).to eq(subject[:email])

        expect(
          MasterData::Account.exists?(uuid: response.parsed_body["uuid"]),
        ).to be true
      end

      it "reject invalid account" do
        post api_v2_accounts_path,
             params: { account: subject.except(:password) },
             headers: json_auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "accept html" do
      it "create an account" do
        post api_v2_accounts_path(format: :html),
             params: { account: subject }, headers: json_auth_headers

        expect(response.body).to include(subject[:email])
      end

      it "reject invalid account" do
        post api_v2_accounts_path(format: :html),
             params: { account: subject.except(:password) },
             headers: json_auth_headers

        expect(response.body).to include("1 error")
        expect(response.body).to include("<form")
      end
    end
  end

  describe "PATCH /api/v2/account" do
    subject { create(:master_data_account, enabled: true) }

    it "update the account" do
      patch api_v2_account_path(subject.uuid),
            params: { account: subject.attributes.merge(enabled: false) },
            headers: json_auth_headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["enabled"]).to be false

      subject.reload
      expect(subject.enabled?).to be false
      expect(subject.updated_by).to eq("client")
    end

    it "reject invalid data" do
      patch api_v2_account_path(subject.uuid),
            params: { account: subject.attributes.merge(gender: "invalid") },
            headers: json_auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v2/account" do
    subject { create(:master_data_account) }

    it "delete the account" do
      delete api_v2_account_path(subject.uuid), headers: json_auth_headers

      expect(response).to have_http_status(:no_content)
      expect(MasterData::Account.exists?(uuid: subject.uuid)).to be false
    end
  end

  describe "Roles management" do
    subject { create(:master_data_account) }
    let(:role) { create(:master_data_role) }

    let(:pending_because_params) do
      pending "broken because controller expects :uuid & :account_uuid params ?"
    end

    describe "adding a role" do
      it "as json" do
        pending_because_params

        post account_add_role_path(account_uuid: subject.uuid),
             params: { role_uuid: role.uuid }, headers: json_auth_headers

        expect(response).to have_http_status(:created)
      end

      it "as html" do
        pending_because_params

        post account_add_role_path(account_uuid: subject.uuid, format: :html),
             params: { role_uuid: role.uuid }, headers: html_auth_headers

        assert_redirected_to api_v2_account_roles_path(
                               account_uuid: subject.uuid,
                             )
      end
    end

    describe "revoking a role" do
      it "as json" do
        pending_because_params

        delete account_revoke_roles_path(
                 account_uuid: subject.uuid, role_uuid: role.uuid,
               ),
               headers: json_auth_headers

        expect(response).to have_http_status(:ok)
      end

      it "as html" do
        pending_because_params

        delete account_revoke_roles_path(
                 account_uuid: subject.uuid,
                 role_uuid: role.uuid,
                 format: :html,
               ),
               headers: html_auth_headers

        assert_redirected_to api_v2_roles_path
      end
    end
  end

  describe "Groups management" do
    subject { create(:master_data_account) }
    let(:group) { create(:master_data_group) }

    let(:pending_because_params) do
      pending "broken because controller expects :uuid & :account_uuid params ?"
    end

    describe "adding a group" do
      it "as json" do
        pending_because_params

        post account_add_to_group_path(account_uuid: subject.uuid),
             params: { group_uuid: group.uuid }, headers: json_auth_headers

        expect(response).to have_http_status(:created)
      end

      it "as html" do
        pending_because_params

        post account_add_to_group_path(
               account_uuid: subject.uuid, format: :html,
             ),
             params: { group_uuid: group.uuid }, headers: html_auth_headers

        assert_redirected_to api_v2_account_groups_path(
                               account_uuid: subject.uuid,
                             )
      end
    end

    describe "removing a role" do
      it "as json" do
        pending_because_params

        delete account_remove_from_group_path(
                 account_uuid: subject.uuid, group_uuid: group.uuid,
               ),
               headers: json_auth_headers

        expect(response).to have_http_status(:ok)
      end

      it "as html" do
        pending_because_params

        delete account_remove_from_group_path(
                 account_uuid: subject.uuid,
                 group_uuid: group.uuid,
                 format: :html,
               ),
               headers: html_auth_headers

        assert_redirected_to api_v2_accounts_path
      end
    end
  end

  describe "ID_SOCE reservation" do
    it "reserve_next_id_soce" do
      post api_v2_accounts_reserve_next_id_soce_path, headers: json_auth_headers

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["id_soce"]).to be_a Integer
    end
  end
end
