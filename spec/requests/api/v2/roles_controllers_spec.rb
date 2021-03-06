require "rails_helper"

RSpec.describe "Api::V2::RolesControllers", type: :request do
  setup { create(:client, :api_client) }

  describe "without headers" do
    it "does not return a 200" do
      get api_v2_roles_path
      expect(response).to_not have_http_status(200)
    end
  end

  describe "GET /api/v2/roles index" do
    let!(:roles) { create_list(:master_data_role, 2) }

    describe "accept json" do
      let(:perform) { get api_v2_roles_path, headers: json_auth_headers }

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")
      end

      it "list roles" do
        perform

        expect(response.parsed_body.length).to eq(2)
        expect(response.parsed_body[0]["uuid"]).to eq(roles[0].uuid)
      end

      it "with group parent" do
        account = create(:master_data_account)
        role = create(:master_data_role, accounts: [account])

        get api_v2_roles_path(account_uuid: account.uuid),
            headers: json_auth_headers

        expect(response.parsed_body.length).to eq(1)
        expect(response.parsed_body[0]["uuid"]).to eq(role.uuid)
      end
    end

    describe "accept html" do
      let(:perform) do
        get api_v2_roles_path(format: :html), headers: html_auth_headers
      end

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to match("text/html")
      end

      it "list roles" do
        perform

        expect(response.body).to include("<th>Name</th>")

        roles.each do |role|
          expect(response.body).to include("<td>#{role.name}</td>")
        end
      end
    end
  end

  describe "GET /api/v2/roles/:uuid" do
    subject { create(:master_data_role) }

    describe "accept json" do
      it "shows the role" do
        get api_v2_role_path(uuid: subject.uuid), headers: json_auth_headers

        expect(response).to have_http_status(200)
        expect(response.parsed_body["uuid"]).to eq(subject.uuid)
        expect(response.parsed_body["name"]).to eq(subject.name)
      end

      it "returns a 404 for an role not found" do
        get api_v2_role_path(uuid: "notfound"), headers: json_auth_headers

        expect(response).to have_http_status(404)
      end
    end

    describe "accept html" do
      it "shows the role" do
        get api_v2_role_path(uuid: subject.uuid, format: :html),
            headers: html_auth_headers

        expect(response).to have_http_status(200)
        expect(response.body).to include(subject.uuid)
        expect(response.body).to include(subject.name)
      end
    end
  end

  describe "POST /api/v2/roles" do
    subject { attributes_for(:master_data_role).except(:uuid) }

    describe "accept json" do
      it "create an role" do
        post api_v2_roles_path,
             params: { role: subject }, headers: json_auth_headers

        expect(response).to have_http_status(:created)
        expect(response.parsed_body["name"]).to eq(subject[:name])

        expect(
          MasterData::Role.exists?(uuid: response.parsed_body["uuid"]),
        ).to be true
      end

      it "reject invalid role" do
        post api_v2_roles_path,
             params: { role: subject.except(:name) }, headers: json_auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "accept html" do
      it "create an role" do
        post api_v2_roles_path(format: :html),
             params: { role: subject }, headers: json_auth_headers

        expect(response.body).to include(subject[:name])
      end

      it "reject invalid role" do
        post api_v2_roles_path(format: :html),
             params: { role: subject.except(:name) }, headers: json_auth_headers

        expect(response.body).to include("1 error")
        expect(response.body).to include("<form")
      end
    end
  end

  describe "PATCH /api/v2/role" do
    subject { create(:master_data_role, name: "orig-name") }

    it "update the role" do
      patch api_v2_role_path(subject.uuid),
            params: { role: subject.attributes.merge(name: "new-name") },
            headers: json_auth_headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["name"]).to eq("new-name")

      subject.reload
      expect(subject.name).to eq("new-name")
    end

    it "reject invalid data" do
      patch api_v2_role_path(subject.uuid),
            params: { role: subject.attributes.merge(name: nil) },
            headers: json_auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v2/role" do
    subject { create(:master_data_role) }

    it "delete the role" do
      pending "As of 2019-09: deletion does not work (same for groups)"
      delete api_v2_role_path(subject.uuid), headers: json_auth_headers

      expect(response).to have_http_status(:no_content)
      expect(MasterData::Role.exists?(uuid: subject.uuid)).to be false
    end
  end
end
