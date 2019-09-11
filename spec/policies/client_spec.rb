require "rails_helper"
require "rolify"

describe ClientPolicy do
  subject { ClientPolicy.new(client, client) }

  let(:client) { create(:master_data_client) }

  context "for a not authenticated client" do
    let(:client) { nil }

    it { should_not permit(:index) }
    it { should_not permit(:edit) }
    it { should_not permit(:create) }
    it { should_not permit(:destroy) }
  end

  context "for a gram_admin" do
    let(:client) { create(:client) }
    before { client.add_role :gram_admin }

    it { should permit(:index) }
    it { should permit(:edit) }
    it { should permit(:create) }
    it { should permit(:destroy) }
  end

  context "for all other connected clients" do
    # TODO : move roles list in client controller
    roles = [
      %i[admin],
      %i[read],
      [:admin, MasterData::Account],
      [:read, MasterData::Account],
      [:admin, MasterData::Group],
      [:read, MasterData::Group],
      [:admin, MasterData::Role],
      [:read, MasterData::Role],
    ]

    roles.each do |role|
      let(:client) { create(:client) }
      if role[1].nil?
        before { client.add_role role[0] }
      else
        before { client.add_role role[0], role[1] }
      end

      it { should_not permit(:index) }
      it { should_not permit(:edit) }
      it { should_not permit(:create) }
      it { should_not permit(:destroy) }
    end
  end
end
