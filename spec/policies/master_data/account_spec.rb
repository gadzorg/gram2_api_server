require "rails_helper"
require 'rolify'

describe MasterData::AccountPolicy do
  subject { MasterData::AccountPolicy.new(client, account) }

  let(:account) {  create(:master_data_account) }

  context "for a not authenticated client" do
    let(:client) { nil }

    it { should_not permit(:index)                }
    it { should_not permit(:show_password_hash)   }
    it { should_not permit(:edit)                 }
    it { should_not permit(:create)               }
    it { should_not permit(:destroy)              }
  end

  context "for a account reader" do
    let(:client) { create(:client)}
    before {client.add_role :read, MasterData::Account}

    it { should permit(:index)       }
    it { should_not permit(:edit)    }
    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for a global reader" do
    let(:client) { create(:client)}
    before {client.add_role :read}

    it { should permit(:index)                    }
    it { should_not permit(:show_password_hash)   }
    it { should_not permit(:edit)                 }
    it { should_not permit(:create)               }
    it { should_not permit(:destroy)              }
  end

  context "for an account admin" do
    let(:client) { create(:client)}
    before {client.add_role :admin, MasterData::Account}

    it { should permit(:index)                    }
    it { should_not permit(:show_password_hash)   }
    it { should permit(:edit)                     }
    it { should permit(:create)                   }
    it { should permit(:destroy)                  }
  end

  context "for a global admin" do
    let(:client) { create(:client)}
    before {client.add_role :admin}

    it { should permit(:index)                    }
    it { should_not permit(:show_password_hash)   }
    it { should permit(:edit)                     }
    it { should permit(:create)                   }
    it { should permit(:destroy)                  }
  end

  context "for a password hash reader" do
    let(:client) { create(:client)}
    before {client.add_role :password_hash_reader, MasterData::Account}

    it { should_not permit(:index)                    }
    it { should permit(:show_password_hash)   }
    it { should_not permit(:edit)                     }
    it { should_not permit(:create)                   }
    it { should_not permit(:destroy)                  }
  end
end
