# All MasterData models should inherit from MasterData::Base
# It defines conneciton to Master Data database
module MasterData
  class Base < ActiveRecord::Base
    self.abstract_class = true
  end

end