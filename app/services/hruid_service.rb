class HruidService
  # build hruid from user info and check uniqness
  def self.generate(user)
    suffix = self.suffix_for(user)
    standard_hruid = self.build(user.firstname, user.lastname, suffix)
    hruid = standard_hruid
    homonyms_count = 1

    loop do
      break hruid unless MasterData::Account.exists?(hruid: hruid)
      homonyms_count += 1
      hruid = "#{standard_hruid}.#{homonyms_count.to_s}"
    end
  end

  # this method is used by alias_service and must stay public
  def self.canonical_name(first_name, last_name)
    first_name = "prenom" if first_name.blank?
    last_name = "nom" if last_name.blank?
    return "#{format_name(first_name)}.#{format_name(last_name.downcase)}"
  end

private
  # build hruid from user info
  def self.build(first_name, last_name, suffix)
    canonical_name = self.canonical_name(first_name, last_name)
    hruid = "#{canonical_name}.#{suffix}"
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

  def self.format_name(name)
    #replace space by "-"
    name = name.gsub(' ', '-')
    #downcase
    name = name.downcase
    #convert special letters
    name = name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/u,'').to_s
    #remove special char
    name = name.gsub(/[^a-z\-]/, '')
  end

end