# All MasterData models should inherit from MasterData::Base
# It defines conneciton to Master Data database
module MasterData
  class Base < ApplicationRecord
    self.abstract_class = true

    # Use uuid in routing
    def to_param
      uuid
    end

    def generate_uuid_if_empty
      self.uuid ||= self.generate_uuid
    end

    def generate_uuid
      self.uuid =
        loop do
          random_uuid = SecureRandom.uuid
          break random_uuid unless self.class.exists?(uuid: random_uuid)
        end
    end

    # Matching with LIKE for searches
    def self.like_condition_scope(col, query)
      self.where(self.arel_table[col].matches("%#{query}%"))
    end

    def self.like(params_hash)
      a = self.all
      params_hash.each { |key, value| a = a.like_condition_scope(key, value) }
      return a
    end
  end
end
