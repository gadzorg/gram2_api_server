# encoding: utf-8
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

      stop_import=0
      i=0
      GorgRabbitmqNotifier.batch do
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
        p stop_import=Time.now
        p "Import #{(stop_import-start).to_f} sec"
        p "Nombre de comptes : #{i}"
        p "#{(stop_import-start).to_f/i} sec par entree"
      end

      p stop=Time.now

      p "Temps d'envoi : #{(stop-stop_import).to_f} sec"
      p "Temps d'envoi par entree : #{(stop-stop_import).to_f/i}"
      p "Temps total : #{(stop-start).to_f} sec"

    else
      puts "#{file_path} does not exist"
      puts "Abord ..."
    end

    
  end

end
