require "json-schema"

class UpdateGroupMessageHandler < ApplicationMessageHandler
  def validate_payload
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "title" => "Create Google Account message schema",
      "type" => "object",
      "properties" => {
        "group_uuid" => {
          "type" => "string",
          "description" => "The unique identifier of linked GrAM Account",
          "pattern" =>
            "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}",
        },
        "name" => {
          "type" => "string", "description" => "Long name of the group"
        },
        "short_name" => {
          "type" => "string", "description" => "String identifier of the group"
        },
        "description" => {
          "type" => "string", "description" => "Description text of the group"
        },
        "members" => {
          "type" => "array",
          "description" => "UUIDs of group members",
          "items" => {
            "type" => "string",
            "pattern" =>
              "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}",
          },
        },
      },
      "additionalProperties" => true,
      "required" => %w[group_uuid name short_name description members],
    }

    errors = JSON::Validator.fully_validate(schema, msg.data)
    if errors.any?
      Rails.logger.error "Data validation error : #{errors.inspect}"
      raise_hardfail("Data validation error", error: errors.inspect)
    end

    Rails.logger.debug "Message data validated"
  end

  def process
    #Recherche du groupe par le UUID, initialisation si groupe inconnu
    group = MasterData::Group.find_or_initialize_by(uuid: msg.data[:group_uuid])

    #Mise à jour des attributes du groupe
    group.name = msg.data[:name]
    group.short_name = msg.data[:short_name]
    group.description = msg.data[:description]
    group.save!

    #Mise à jour des membres
    #calcul des membres à ajouter/supprimer
    current_members = group.accounts
    target_members =
      msg.data[:members].map do |uuid|
        MasterData::Account.find_by(uuid: uuid) ||  raise
      end #Je te laisse définir ce qui se passe si le membre n'existe pas

    to_add_m = (target_members - current_members)
    to_del_m = (current_members - target_members)
    Rails.logger.debug("Add members: #{to_add_m.map(&:uuid)}")
    Rails.logger.debug("Del members: #{to_del_m.map(&:uuid)}")

    #Ajout des membres
    to_add_m.each { |account| group.accounts << account }

    #Suppression des membres
    to_del_m.each { |account| group.accounts.delete(account) }
  end
end
