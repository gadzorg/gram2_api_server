require 'rails_helper'

RSpec.describe UpdateGroupMessageHandler, type: :message_handler do

  subject {UpdateGroupMessageHandler.new(message)}
  
  let(:valid_message_payload) {
    {group_uuid:"70dc1fdb-7964-446e-849e-fedffa4b631e",name:"Dragon's Team",short_name:"dragon",description:"Equipe",members:members_uuid_list}
  }
  let(:members_uuid_list) {[FactoryGirl.create(:master_data_account).uuid,FactoryGirl.create(:master_data_account).uuid]}

  let(:invalid_message_payload) {
    {group_uuid:"70dc1fdb-7964-446e-849e",name:"Dragon Team",short_name:"dragon",description:"Equipe"}
  }

  let(:message){GorgService::Message.new(data:valid_message_payload)}

  context "whren there is an invalid payload" do
    let(:message){GorgService::Message.new(data:invalid_message_payload)}

    it "raise an hardfail error" do
      raise_error(GorgService::HardfailError)
    end
  end

  context "when there is a valid payload" do
    let(:message){GorgService::Message.new(data:valid_message_payload)}

    context "new group" do
      it "create a new group" do
        change(MasterData::Group, :count).by(1)
      end
    end

    context "existing group" do
      let(:group) {FactoryGirl.create(:master_data_group)}
      let(:user1) {FactoryGirl.create(:master_data_account)}
      let(:user2) {FactoryGirl.create(:master_data_account)}
      let(:user3) {FactoryGirl.create(:master_data_account)}

      context "without members" do
        let(:members_uuid_list) {[]}

        let(:valid_message_payload) {
           {group_uuid:group.uuid,name:"Dragon's Team",short_name:"dragon",description:"Equipe",members:members_uuid_list}
        }

        describe "update group data" do
          before(:each) do
            subject
            group.reload
          end

          it "update name" do
            expect(group.name).to eq("Dragon's Team")
          end

          it "update short_name" do
            expect(group.short_name).to eq("dragon")
          end

          it "update description" do
            expect(group.description).to eq("Equipe")
          end
        end

        context "with members" do
          let(:members_uuid_list) {[user1.uuid,user3.uuid]}
          before(:each) {group.accounts << [user1,user2]}

          before(:each) do
            subject
            group.reload
          end

          it "add new members" do
            expect(group.accounts).to include(user3)
          end

          it "delete removed members" do
            expect(group.accounts).not_to include(user2)
          end

        end


      end
    end
  end

end