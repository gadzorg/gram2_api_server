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

  end

end