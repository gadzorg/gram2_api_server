require 'spec_helper'
require 'rolify'

describe MasterData::GroupPolicy do
  subject { MasterData::GroupPolicy.new(client, group) }

  let(:group) { FactoryGirl.create(:master_data_group) }

  context "for a not authenticated client" do
    let(:client) { nil }

    it { should_not permit(:index)    }
    it { should_not permit(:show)    }
    it { should_not permit(:new)     }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
    it { should_not permit(:index_account) }
    it { should_not permit(:show_account) }
  end

  context "for an admin client" do
    let(:client) {FactoryGirl.create(:client)}
    before {client.add_role :admin, MasterData::Group}

    it { should permit(:index)    }
    it { should permit(:show)    }
    it { should permit(:new)     }
    it { should permit(:edit)    }
    it { should permit(:create)  }
    it { should permit(:update)  }
    it { should permit(:destroy) }
    it { should permit(:index_account) }
    it { should permit(:show_account) }
  end
end