require 'spec_helper'
require 'rolify'

describe ClientPolicy do
  subject { ClientPolicy.new(client, client) }

  let(:client) { FactoryGirl.create(:master_data_client) }

  context "for a not authenticated client" do
    let(:client) { nil }

    it { should_not permit(:index)                }
    it { should_not permit(:edit)                 }
    it { should_not permit(:create)               }
    it { should_not permit(:destroy)              }
  end

  context "for a gram_admin" do
    let(:client) {FactoryGirl.create(:client)}
    before {client.add_role :gram_admin }

    it { should permit(:index)       }
    it { should permit(:edit)    }
    it { should permit(:create)  }
    it { should permit(:destroy) }
  end

  context "for all other connected clients" do
    # TODO : move roles list in client controller
    roles = [
      [:admin],
      [:read],
      [:admin, MasterData::Account],
      [:read, MasterData::Account],
      [:admin, MasterData::Group],
      [:read, MasterData::Group],
      [:admin, MasterData::Role],
      [:read, MasterData::Role]
    ]

    roles.each do |role|
      let(:client) {FactoryGirl.create(:client)}
      role[1].nil? ? before {client.add_role role[0]} : before {client.add_role role[0], role[1]}

      it { should_not permit(:index)                    }
      it { should_not permit(:edit)                 }
      it { should_not permit(:create)               }
      it { should_not permit(:destroy)              }
    end
  end

end