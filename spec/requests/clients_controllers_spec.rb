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
      let(:perform) { get clients_path, nil, standard_headers }

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
        get clients_path(format: :html), nil, standard_html_headers
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
        get client_path(id: subject.id), nil, standard_headers

        expect(response).to have_http_status(200)
        expect(json_body["id"]).to eq(subject.id)
        expect(json_body["email"]).to eq(subject.email)
      end

      it "returns a 404 for an client not found" do
        get client_path(id: "notfound"), nil, standard_headers

        expect(response).to have_http_status(404)
      end
    end

    describe "accept html" do
      it "shows the client" do
        get client_path(id: subject.id, format: :html),
            nil,
            standard_html_headers

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
        post clients_path, { client: subject }, standard_headers

        expect(response).to have_http_status(:created)
        expect(json_body["email"]).to eq(subject[:email])

        expect(Client.exists?(id: json_body["id"])).to be true
      end

      it "reject invalid client" do
        pending "no validation for Client model"

        post clients_path, { client: subject.except(:email) }, standard_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "accept html" do
      it "create an client" do
        post clients_path(format: :html), { client: subject }, standard_headers

        assert_redirected_to client_path(Client.last.id)
      end

      it "reject invalid client" do
        pending "no validation for Client model"

        post clients_path(format: :html),
             { client: subject.except(:email) },
             standard_headers

        expect(response.body).to include("1 error")
        expect(response.body).to include("<form")
      end
    end
  end

  describe "PATCH /client" do
    subject { create(:client, name: "orig-name") }

    it "update the client" do
      patch client_path(subject.id),
            { client: subject.attributes.merge(name: "new-name") },
            standard_headers

      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq "new-name"

      subject.reload
      expect(subject.name).to eq "new-name"
    end

    it "reject invalid data" do
      pending "no validation for Client model"

      patch client_path(subject.id),
            { client: subject.attributes.merge(email: nil) },
            standard_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /client" do
    subject { create(:client) }

    it "delete the client" do
      delete client_path(subject.id), nil, standard_headers

      expect(response).to have_http_status(:no_content)
      expect(Client.exists?(id: subject.id)).to be false
    end
  end
end
