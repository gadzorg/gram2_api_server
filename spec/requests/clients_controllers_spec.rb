# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ClientsControllers", type: :request do
  setup { create(:client, :api_client) }

  describe "without headers" do
    it "does not return a 200" do
      get clients_path
      expect(response).to_not have_http_status(200)
    end
  end

  describe "GET /clients index" do
    let!(:clients) { create_list(:client, 2) }

    describe "accept json" do
      let(:perform) { get clients_path, headers: json_auth_headers }

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")
      end

      it "list clients" do
        perform

        # 3 clients because it's include API client created during setup
        expect(json_body.length).to eq(3)
        expect(json_body[2]["id"]).to eq(clients.last.id)
      end
    end

    describe "accept html" do
      let(:perform) do
        get clients_path(format: :html), headers: html_auth_headers
      end

      it "returns expected headers" do
        perform

        expect(response).to have_http_status(200)
        expect(response.content_type).to match("text/html")
      end

      it "list clients" do
        perform

        expect(response.body).to include("<th>Name</th>")

        clients.each do |client|
          expect(response.body).to include("<td>#{client.name}</td>")
        end
      end
    end
  end

  describe "GET /clients/:id" do
    subject { create(:client) }

    describe "accept json" do
      it "shows the client" do
        get client_path(id: subject.id), headers: json_auth_headers

        expect(response).to have_http_status(200)
        expect(json_body["id"]).to eq(subject.id)
        expect(json_body["email"]).to eq(subject.email)
      end

      it "returns a 404 for an client not found" do
        get client_path(id: "notfound"), headers: json_auth_headers

        expect(response).to have_http_status(404)
      end
    end

    describe "accept html" do
      it "shows the client" do
        get client_path(id: subject.id, format: :html),
            headers: html_auth_headers

        expect(response).to have_http_status(200)
        expect(response.body).to include(subject.name)
        expect(response.body).to include(subject.email)
      end
    end
  end

  describe "POST /clients" do
    subject { attributes_for(:client).except(:id) }

    describe "accept json" do
      it "create an client" do
        post clients_path,
             params: { client: subject }, headers: json_auth_headers

        expect(response).to have_http_status(:created)
        expect(json_body["email"]).to eq(subject[:email])

        expect(Client.exists?(id: json_body["id"])).to be true
      end

      it "reject invalid client" do
        pending "no validation for Client model"

        post clients_path,
             params: { client: subject.except(:email) },
             headers: json_auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "accept html" do
      it "create an client" do
        post clients_path(format: :html),
             params: { client: subject }, headers: json_auth_headers

        assert_redirected_to client_path(Client.last.id)
      end

      it "reject invalid client" do
        pending "no validation for Client model"

        post clients_path(format: :html),
             params: { client: subject.except(:email) },
             headers: json_auth_headers

        expect(response.body).to include("1 error")
        expect(response.body).to include("<form")
      end
    end
  end

  describe "PATCH /client" do
    subject { create(:client, name: "orig-name") }

    it "update the client" do
      patch client_path(subject.id),
            params: { client: subject.attributes.merge(name: "new-name") },
            headers: json_auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq "new-name"

      subject.reload
      expect(subject.name).to eq "new-name"
    end

    it "reject invalid data" do
      pending "no validation for Client model"

      patch client_path(subject.id),
            params: { client: subject.attributes.merge(email: nil) },
            headers: json_auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /client" do
    subject { create(:client) }

    it "delete the client" do
      delete client_path(subject.id), headers: json_auth_headers

      expect(response).to have_http_status(:no_content)
      expect(Client.exists?(id: subject.id)).to be false
    end
  end

  describe "Roles management" do
    subject { create(:client) }

    describe "Adding a role" do
      it "without resource" do
        post client_add_role_path(subject.id),
             params: { role_name: "read" }, headers: html_auth_headers

        assert_redirected_to client_path(subject.id)
      end

      it "with resource" do
        post client_add_role_path(subject.id),
             params: { role_name: "admin", ressource: "MasterData::Account" },
             headers: html_auth_headers

        assert_redirected_to client_path(subject.id)
      end
    end

    describe "Removing a role" do
      it "without resource" do
        post client_remove_role_path(subject.id),
             params: { role_name: "read" }, headers: html_auth_headers

        assert_redirected_to client_path(subject.id)
      end

      it "with resource" do
        post client_remove_role_path(subject.id),
             params: { role_name: "admin", ressource: "MasterData::Account" },
             headers: html_auth_headers

        assert_redirected_to client_path(subject.id)
      end
    end
  end
end
