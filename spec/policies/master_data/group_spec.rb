require "rails_helper"
require 'rolify'

describe MasterData::GroupPolicy do
  subject { MasterData::GroupPolicy.new(client, group) }

  let(:group) { create(:master_data_group) }

  context "for a not authenticated client" do
    let(:client) { nil }

    it { should_not permit(:index)   }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for a group reader" do
    let(:client) {create(:client)}
    before {client.add_role :read, MasterData::Group}

    it { should permit(:index)       }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for a global reader" do
    let(:client) {create(:client)}
    before {client.add_role :read}

    it { should permit(:index)       }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for a group admin" do
    let(:client) {create(:client)}
    before {client.add_role :admin, MasterData::Group}

    it { should permit(:index)   }
    it { should permit(:edit)    }
    it { should permit(:create)  }
    it { should permit(:destroy) }
  end

  context "for a global admin" do
    let(:client) {create(:client)}
    before {client.add_role :admin}

    it { should permit(:index)   }
    it { should permit(:edit)    }
    it { should permit(:create)  }
    it { should permit(:destroy) }
  end
end
