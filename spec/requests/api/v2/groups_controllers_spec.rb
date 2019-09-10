require "rails_helper"

RSpec.describe "Api::V2::GroupsControllers", type: :request do
  setup { create(:client, :api_client) }

  describe "without headers" do
    it "does not return a 200" do
      get api_v2_groups_path
      expect(response).to_not have_http_status(200)
    end
  end

  describe "GET /api/v2/groups index" do
    let!(:groups) { create_list(:master_data_group, 2) }

    describe "accept json" do
      let(:perform) { get api_v2_groups_path, nil, standard_headers }

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq "application/json"
      end

      it "list groups" do
        perform

        expect(json_body.length).to eq(2)
        expect(json_body[0]["uuid"]).to eq(groups[0].uuid)
        expect(json_body[0]["name"]).to eq(groups[0].name)
      end

      it "filter" do
        get api_v2_groups_path(name: groups[0].name), nil, standard_headers

        expect(json_body.length).to eq(1)
        expect(json_body[0]["uuid"]).to eq(groups[0].uuid)
      end

      it "filter, exact search" do
        get api_v2_groups_path(
              name: groups[0].name[0..-2], exact_search: "false",
            ),
            nil,
            standard_headers

        expect(json_body.length).to eq(1)
        expect(json_body[0]["uuid"]).to eq(groups[0].uuid)
      end

      it "with account parent" do
        account = create(:master_data_account)
        group = create(:master_data_group, accounts: [account])

        get api_v2_groups_path(account_uuid: account.uuid),
            nil,
            standard_headers

        expect(json_body.length).to eq(1)
        expect(json_body[0]["uuid"]).to eq(group.uuid)
      end
    end

    describe "accept html" do
      let(:perform) do
        get api_v2_groups_path(format: :html), nil, standard_html_headers
      end

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to match("text/html")
      end

      it "list groups" do
        perform

        expect(response.body).to include("<th>Name</th>")

        groups.each do |group|
          expect(response.body).to include("<td>#{group.name}</td>")
        end
      end
    end
  end

  describe "GET /api/v2/groups/:uuid" do
    subject { create(:master_data_group) }

    describe "accept json" do
      it "shows the group" do
        get api_v2_group_path(uuid: subject.uuid), nil, standard_headers

        expect(response).to have_http_status(200)
        expect(json_body["uuid"]).to eq(subject.uuid)
        expect(json_body["name"]).to eq(subject.name)
      end

      it "returns a 404 for an group not found" do
        get api_v2_group_path(uuid: "notfound"), nil, standard_headers

        expect(response).to have_http_status(404)
      end
    end

    describe "accept html" do
      it "shows the group" do
        get api_v2_group_path(uuid: subject.uuid, format: :html),
            nil,
            standard_html_headers

        expect(response).to have_http_status(200)
        expect(response.body).to include(subject.uuid)
        expect(response.body).to include(subject.name)
      end
    end
  end

  describe "POST /api/v2/groups" do
    subject { attributes_for(:master_data_group).except(:uuid) }

    describe "accept json" do
      it "create an group" do
        post api_v2_groups_path, { group: subject }, standard_headers

        expect(response).to have_http_status(:created)
        expect(json_body["name"]).to eq(subject[:name])

        expect(MasterData::Group.exists?(uuid: json_body["uuid"])).to be true
      end

      it "reject invalid group" do
        post api_v2_groups_path,
             { group: subject.except(:name) },
             standard_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "accept html" do
      it "create an group" do
        post api_v2_groups_path(format: :html),
             { group: subject },
             standard_headers

        expect(response.body).to include(subject[:name])
      end

      it "reject invalid group" do
        post api_v2_groups_path(format: :html),
             { group: subject.except(:name) },
             standard_headers

        expect(response.body).to include("1 error")
        expect(response.body).to include("<form")
      end
    end
  end

  describe "PATCH /api/v2/group" do
    subject { create(:master_data_group, name: "orig-name") }

    it "update the group" do
      patch api_v2_group_path(subject.uuid),
            { group: subject.attributes.merge(name: "new-name") },
            standard_headers

      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq("new-name")

      subject.reload
      expect(subject.name).to eq("new-name")
    end

    it "reject invalid data" do
      patch api_v2_group_path(subject.uuid),
            { group: subject.attributes.merge(name: nil) },
            standard_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v2/group" do
    subject { create(:master_data_group) }

    it "delete the group" do
      pending "As of 2019-09: deletion does not work (same for roles)"
      delete api_v2_group_path(subject.uuid), nil, standard_headers

      expect(response).to have_http_status(:no_content)
      expect(MasterData::Group.exists?(uuid: subject.uuid)).to be false
    end
  end
end
