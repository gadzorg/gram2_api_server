require "rails_helper"

RSpec.describe "Clients::SessionsControllers", type: :request do
  before { create(:client, :api_client, password: "password") }
  subject { Client.last }

  describe "POST /clients/sign_in" do
    describe "successful" do
      let(:params) { { client: { name: "client", password: "password" } } }

      it "create a new session" do
        post client_session_path, params, { "Accept" => "application/json" }

        # TODO why a redirection for a json request ??
        assert_redirected_to root_path
        assert_in_delta subject.last_sign_in_at, Time.zone.now, 1.second
      end

      it "as html" do
        post client_session_path(format: :html), params

        assert_redirected_to root_path
        assert_in_delta subject.last_sign_in_at, Time.zone.now, 1.second
      end
    end

    describe "wrong credentials" do
      describe "as json" do
        it "client not found" do
          post client_session_path,
               { client: { name: "notfound", password: "" } },
               { "Accept" => "application/json" }

          expect(response).to have_http_status(401)
          expect(json_body["success"]).to be false
        end

        it "wrong password" do
          post client_session_path,
               { client: { name: "client", password: "oops" } },
               { "Accept" => "application/json" }

          expect(response).to have_http_status(401)
          expect(json_body["success"]).to be false
        end
      end

      describe "as html" do
        it "client not found" do
          post client_session_path(format: :html),
               { client: { name: "notfound", password: "" } },
               { "Accept" => "application/json" }

          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
