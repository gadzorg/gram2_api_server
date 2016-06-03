#credit : https://github.com/Zooip/ProfileDirectoryAPI/blob/master/lib/tasks/migrate.rake
namespace :master_data do
  namespace :db do
    desc 'Migrates the master_data database'
    task :migrate => :environment do
      with_master_data_connection do
        ActiveRecord::Migrator.migrate("db/migrate_master_data/")
      end
    end
  end
end

namespace :db do
  
end

# Hack to temporarily connect AR::Base to your engine.
def with_master_data_connection
  original = ActiveRecord::Base.remove_connection
  ActiveRecord::Base.establish_connection MASTER_DATA_DB_CONF
  yield
ensure
  ActiveRecord::Base.establish_connection original
end
