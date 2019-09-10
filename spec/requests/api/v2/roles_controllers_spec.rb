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
      let(:perform) { get api_v2_roles_path, nil, standard_headers }

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")
      end

      it "list roles" do
        perform

        expect(json_body.length).to eq(2)
        expect(json_body[0]["uuid"]).to eq(roles[0].uuid)
      end
    end

    describe "accept html" do
      let(:perform) do
        get api_v2_roles_path(format: :html), nil, standard_html_headers
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
        get api_v2_role_path(uuid: subject.uuid), nil, standard_headers

        expect(response).to have_http_status(200)
        expect(json_body["uuid"]).to eq(subject.uuid)
        expect(json_body["name"]).to eq(subject.name)
      end

      it "returns a 404 for an role not found" do
        get api_v2_role_path(uuid: "notfound"), nil, standard_headers

        expect(response).to have_http_status(404)
      end
    end

    describe "accept html" do
      it "shows the role" do
        get api_v2_role_path(uuid: subject.uuid, format: :html),
            nil,
            standard_html_headers

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
        post api_v2_roles_path, { role: subject }, standard_headers

        expect(response).to have_http_status(:created)
        expect(json_body["name"]).to eq(subject[:name])

        expect(MasterData::Role.exists?(uuid: json_body["uuid"])).to be true
      end

      it "reject invalid role" do
        post api_v2_roles_path,
             { role: subject.except(:name) },
             standard_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "accept html" do
      it "create an role" do
        post api_v2_roles_path(format: :html),
             { role: subject },
             standard_headers

        expect(response.body).to include(subject[:name])
      end

      it "reject invalid role" do
        post api_v2_roles_path(format: :html),
             { role: subject.except(:name) },
             standard_headers

        expect(response.body).to include("1 error")
        expect(response.body).to include("<form")
      end
    end
  end

  describe "PATCH /api/v2/role" do
    subject { create(:master_data_role, name: "orig-name") }

    it "update the role" do
      patch api_v2_role_path(subject.uuid),
            { role: subject.attributes.merge(name: "new-name") },
            standard_headers

      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq("new-name")

      subject.reload
      expect(subject.name).to eq("new-name")
    end

    it "reject invalid data" do
      patch api_v2_role_path(subject.uuid),
            { role: subject.attributes.merge(name: nil) },
            standard_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v2/role" do
    subject { create(:master_data_role) }

    it "delete the role" do
      pending "As of 2019-09: deletion does not work (same for groups)"
      delete api_v2_role_path(subject.uuid), nil, standard_headers

      expect(response).to have_http_status(:no_content)
      expect(MasterData::Role.exists?(uuid: subject.uuid)).to be false
    end
  end
end
