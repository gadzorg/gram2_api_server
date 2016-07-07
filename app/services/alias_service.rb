class AliasService
  # build alias list
  def self.generate_list(user)
    list = Array.new
    # hruid
    # idsoce
    # prenom.nom (hruid w/o suffix)
    # email
    list << user.hruid
    list << user.id_soce
    list << user.email

    # add canonical name if uniq
    canonical_name =  HruidService::canonical_name(user.firstname, user.lastname)
    list << canonical_name unless MasterData::Alias.exists?(name: canonical_name)
    return list
  end
end