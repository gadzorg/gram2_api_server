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

      to_delete_keys=[]
      r.set "account_count",0
      to_delete_keys<<"account_count"

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

          if account.email.present? && (temp=r.get("accout_#{account.email}_validate"))  && temp != account.uuid
            duplicates_email << account.email
            account.audit_status="errors"
            account.audit_comments||="Errors from legagy"
            account.audit_comments+= " -- duplicate email from #{temp}"
          end
          if (temp=r.get("accout_#{account.id_soce}_validate")) && temp != account.uuid
            duplicates_id_soce << account.id_soce
            account.audit_status="errors"
            account.audit_comments||="Errors from legagy"
            account.audit_comments+= " -- duplicate id Soce from #{temp}"
          end
          if account.gapps_id.present? && (temp=r.get("accout_#{account.gapps_id}_validate")) && temp != account.uuid
            duplicates_gapps_id << account.gapps_id
            account.audit_status="errors"
            account.audit_comments||="Errors from legagy"
            account.audit_comments+= " -- duplicate Gapps_id from #{temp}"
          end

          r.set "accout_#{account.email}_validate" , account.uuid
          to_delete_keys<<"accout_#{account.email}_validate"
          r.set "accout_#{account.id_soce}_validate", account.uuid
          to_delete_keys<<"accout_#{account.id_soce}_validate"
          r.set "accout_#{account.gapps_id}_validate", account.uuid
          to_delete_keys<<"accout_#{account.gapps_id}_validate"


          to_add_aliases=[]
          aliases.each do |al|
            if (temp=r.get("aliases_validate_#{al}")) && temp != account.uuid
              duplicates_aliases << al
              account.audit_status="errors"
              account.audit_comments||="Errors from legagy"
              account.audit_comments+= " -- was duplicating alias '#{al}' from #{temp} ; alias deleted"
            else
              r.set "aliases_validate_#{al}", account.uuid
              to_delete_keys<<"aliases_validate_#{al}"
              to_add_aliases<<al
            end
          end
          r.set "account_#{id}", account.serializable_hash.select{|k,v| v!= nil}.to_json
          r.set "aliases_#{account.uuid}", to_add_aliases.to_json
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
        if duplicates_gapps_id.any?
          p "duplicates_gapps_ids"
          p duplicates_gapps_id
        end
        if duplicates_aliases.any?
          p "duplicates_aliases"
          p duplicates_aliases
        end


        p "Import Accounts"
        account_count= r.get("account_count").to_i


        (1..account_count).each_slice(5000) do |enum|
          p "Import from #{enum.first} to #{enum.last}"
          puts Benchmark.measure {
            accounts=[]
            enum.each do |id|
              acc=MasterData::Account.new(JSON.parse(r.get "account_#{id}"))
              r.del "account_#{id}"
              accounts<<acc
            end
            GorgRabbitmqNotifier.batch do
              MasterData::Account.import accounts, :validate => false

              p "Build Aliases"
              aliases_batch=[]
              accounts.each do |a|
                aliases = JSON.parse(r.get "aliases_#{a.uuid}")
                r.del "aliases_#{a.uuid}"
                aliases.each do |al|
                  alo=MasterData::Alias.new(name: al, account_id:a.id)
                  aliases_batch<<alo
                end
              end
              p "Import Aliases"
              MasterData::Alias.import aliases_batch, :validate => false
            end
          }
        end

        p "Cleanup redis DB"
        r.del to_delete_keys
        
        p stop_import=Time.now
        
        # p "Sending Rabbitmq notifications ..."
        # MasterData::Account.find_in_batches(batch_size: 5000)do |accounts|
        #   GorgRabbitmqNotifier.batch do
        #     p "New batch"
        #     accounts.each do |a|
        #       a.send_rabbitmq_notification('created', MasterData::AccountSerializer.new(a).attributes.map{|k,v| [k,[nil,v]]}.to_h)
        #     end
        #   end
        # end

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
