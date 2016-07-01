require 'spec_helper'
require 'rolify'

describe MasterData::RolePolicy do
  subject { MasterData::RolePolicy.new(client, role) }

  let(:role) { FactoryGirl.create(:master_data_role) }

  context "for a not authenticated client" do
    let(:client) { nil }

    it { should_not permit(:index)   }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for a role reader" do
    let(:client) {FactoryGirl.create(:client)}
    before {client.add_role :read, MasterData::Role}

    it { should permit(:index)       }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for a global reader" do
    let(:client) {FactoryGirl.create(:client)}
    before {client.add_role :read}

    it { should permit(:index)       }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for a role admin" do
    let(:client) {FactoryGirl.create(:client)}
    before {client.add_role :admin, MasterData::Role}

    it { should permit(:index)   }
    it { should permit(:edit)    }
    it { should permit(:create)  }
    it { should permit(:destroy) }
  end

  context "for a global admin" do
    let(:client) {FactoryGirl.create(:client)}
    before {client.add_role :admin}

    it { should permit(:index)   }
    it { should permit(:edit)    }
    it { should permit(:create)  }
    it { should permit(:destroy) }
  end
end