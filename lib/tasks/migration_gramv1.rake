# encoding: utf-8
require 'csv'
require 'json'
require 'digest/sha1'
require 'activerecord-import'
require 'redis'

class Array
  def subtract_once(b)
    h = b.inject({}) {|memo, v|
      memo[v] ||= 0; memo[v] += 1; memo
    }
    reject { |e| h.include?(e) && (h[e] -= 1) >= 0 }
  end
end

namespace :migration_gramv1 do
  desc "Import accounts from a csv file"
  task :import_accounts_from_csv, [:file_path] => [:environment] do

    ARGV.each { |a| task a.to_sym do ; end } #dynamically mockup tasks

    file_path=ARGV[1]




    if File.exists? file_path
      r= ENV['REDIS_URL'] ? Redis.new(ENV['REDIS_URL']) : Redis.new()
      p start=Time.now
      MasterData::Account.delete_all
      MasterData::Alias.delete_all

      r.set "account_count",0


      stop_import=0
      i=0

      
        aliases_store={}


        p "Build Accounts"
        duplicates_email=[]
        duplicates_hruid=[]
        duplicates_id_soce=[]
        duplicates_gapps_id=[]
        duplicates_aliases=[]
        CSV.foreach(file_path, headers: true) do |row|

          i+=1
          puts i if i % 1000 == 0

          id=r.incr("account_count")

          
          data=row.to_h
          aliases=JSON.parse(data.delete("aliases")||"[]")
          account=MasterData::Account.new(data)
          account.password||=Digest::SHA1.hexdigest([Time.now, rand].join)
          account.is_from_legacy_gram1=true
          #account.run_callbacks(:save) { false }

          duplicates_email << account.email if account.email.present? && (temp=r.get("accout_#{account.email}_validate"))  && temp != account.uuid
          duplicates_hruid << account.hruid if (temp=r.get("accout_#{account.hruid}_validate")) && temp != account.uuid
          duplicates_id_soce << account.id_soce if (temp=r.get("accout_#{account.id_soce}_validate")) && temp != account.uuid
          duplicates_gapps_id << account.gapps_id if account.gapps_id.present? && (temp=r.get("accout_#{account.gapps_id}_validate")) && temp != account.uuid

          r.set "accout_#{account.email}_validate" , account.uuid
          r.set "accout_#{account.hruid}_validate", account.uuid
          r.set "accout_#{account.id_soce}_validate", account.uuid
          r.set "accout_#{account.gapps_id}_validate", account.uuid

          r.set "account_#{id}", account.serializable_hash.select{|k,v| v!= nil}.to_json

          aliases.each do |al|
            duplicates_aliases << al if (temp=r.get("aliases_validate_#{al}")) && temp != account.uuid
            r.set "aliases_validate_#{al}", account.uuid
          end
          r.set "aliases_#{account.uuid}", aliases.to_json
        end


        p "Validate Accounts"

        if duplicates_email.any?
          p "duplicates_emails"
          p duplicates_email
        end
        if duplicates_id_soce.any?
          p "duplicates_id_soces"
          p duplicates_id_soce
        end
        if duplicates_hruid.any?
          p "duplicates_hruids"
          p duplicates_hruid
        end
        if duplicates_gapps_id.any?
          p "duplicates_gapps_ids"
          p duplicates_gapps_id
        end
        if duplicates_aliases.any?
          p "duplicates_aliases"
          p duplicates_aliases
        end

        raise if duplicates_email.any?||duplicates_uuid.any?||duplicates_id_soce.any?||duplicates_hruid.any?||duplicates_gapps_id.any?||duplicates_aliases.any?


        p "Import Accounts"
        account_count= r.get("account_count").to_i


        (1..account_count).each_slice(5000) do |enum|
          p "Import from #{enum.first} to #{enum.last}"
          p Benchmark.measure {
            accounts=[]
            enum.each do |id|
              acc=MasterData::Account.new(JSON.parse(r.get "account_#{id}"))
              accounts<<acc
            end
            GorgRabbitmqNotifier.batch do
              MasterData::Account.import accounts, :validate => false

              p "Build Aliases"
              aliases_batch=[]
              accounts.each do |a|
                aliases = JSON.parse(r.get "aliases_#{a.uuid}")
                aliases.each do |al|
                  alo=MasterData::Alias.new(name: al, account_id:a.id)
                  aliases_batch<<alo
                end
              end
              MasterData::Alias.import aliases_batch, :validate => false
            end
          }
        end





        
        p stop_import=Time.now
        p "Import #{(stop_import-start).to_f} sec"
        p "Nombre de comptes : #{i}"
        p "#{(stop_import-start).to_f/i} sec par entree"

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
