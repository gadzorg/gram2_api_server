class AliasService
  # build alias list
  def self.generate_list(user)
    list = Array.new
    # hruid
    # idsoce
    # idsoce with letter
    # prenom.nom (hruid w/o suffix)
    # email

    letters = ("A".."Z").to_a
    id_soce_with_letter = user.id_soce.to_s + letters[(user.id_soce % 23)]

    list << user.hruid
    list << user.id_soce
    list << id_soce_with_letter
    list << user.email if user.email

    # add canonical name if uniq
    canonical_name = HruidService.canonical_name(user.firstname, user.lastname)
    unless MasterData::Alias.exists?(name: canonical_name)
      list << canonical_name
    end
    return list
  end
end
