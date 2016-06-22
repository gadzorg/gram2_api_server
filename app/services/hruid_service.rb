class HruidService
  # build hruid from user info and check uniqness
  def self.generate(user)
    suffix = self.suffix_for(user)
    standard_hruid = self.build(user.firstname, user.lastname, suffix)
    hruid = standard_hruid
    homonyms_count = 0

    loop do
      break hruid unless MasterData::Account.exists?(hruid: hruid)
      homonyms_count += 1
      hruid = "#{standard_hruid}.#{homonyms_count.to_s}"
    end
  end

private
  # build hruid from user info
  def self.build(first_name, last_name, suffix)
    first_name = "prenom" if first_name.blank?
    last_name = "nom" if last_name.blank? 

    hruid = "#{first_name}.#{last_name}.#{suffix}"
  end

  # generate hruid from user type
  # suffix = {"soce", "ext", promo}
  def self.suffix_for(user)
    if user.gadz_proms_principale
      suffix= user.gadz_proms_principale.to_s
    elsif user.is_soce_employee
      suffix = "soce" 
    else
      suffix = "ext"     
    end
  end

end