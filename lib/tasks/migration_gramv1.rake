require 'csv'
require 'digest/sha1'

namespace :migration_gramv1 do
  desc "Import accounts from a csv file"
  task :import_accounts_from_csv, [:file_path] => [:environment] do

    ARGV.each { |a| task a.to_sym do ; end } #dynamically mockup tasks

    file_path=ARGV[1]

    if File.exists? file_path
      p start=Time.now
      MasterData::Account.delete_all

       i=0
      CSV.foreach(file_path, headers: true) do |row|

        i+=1
        puts i if i % 1000 == 0


        data=row.to_h
        aliases=data.delete("aliases")

        account=MasterData::Account.new(data)
        account.password||=Digest::SHA1.hexdigest([Time.now, rand].join)
        account.is_from_legacy_gram1=true

        unless account.save
          p account.errors.messages
        end

      end
      p stop=Time.now
      p "#{(stop-start).to_f} sec"
      p "Nombre de comptes : #{i}"
      p "#{(stop-start).to_f/i} sec par entree"
    else
      puts "#{file_path} does not exist"
      puts "Abord ..."
    end

    
  end

end
