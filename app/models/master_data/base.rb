# All MasterData models should inherit from MasterData::Base
# It defines conneciton to Master Data database
module MasterData
  class Base < ActiveRecord::Base
    self.abstract_class = true
    def generate_uuid_if_empty
      self.uuid ||= self.generate_uuid
    end

    def generate_uuid
      self.uuid = loop do
        random_uuid = SecureRandom.uuid
        break random_uuid unless self.class.exists?(uuid: random_uuid)
      end
    end

    ################# LDAP #################
    # this function is here because it is shared between alias and account models
    def request_account_ldap_sync(ldap_daemon = LdapDaemon.new, account = self)
      ldap_daemon.request_account_update(account)
    end
  end
end