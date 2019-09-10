require "active_support/concern"

module GorgRabbitmqNotifier::ActiveRecordExtension
  extend ActiveSupport::Concern

  included do
    # Class methods
    def self.rabbitmq_id(method_name = nil, &block)
      @rabbitmq_id_proc =
        (block_given? ? block : Proc.new { |o| o.send(method_name) })
    end

    def self.rabbitmq_resource_type(resource_type)
      @rabbitmq_resource_type = resource_type
    end

    def self.get_rabbitmq_resource_type
      @rabbitmq_resource_type || self.model_name.singular
    end

    around_save :capture_serialisation_changes
    # Instance methods
    def rabbitmq_id
      self.class.rabbitmq_id_proc.call(self)
    end

    def send_rabbitmq_notification(action, changes = {})
      message =
        GorgRabbitmqNotifier::NotificationMessage.new(
          resource_type: self.class.get_rabbitmq_resource_type,
          action: action.to_s,
          resource_id_attribute: "key",
          resource_id_value: rabbitmq_id,
          changes: changes,
        )
      message.commit!
    end

    protected

    def self.rabbitmq_id_proc
      @rabbitmq_id_proc
    end

    def capture_add_association(object)
      capture_association_modification(:add, object)
    end

    def capture_del_association(object)
      capture_association_modification(:delete, object)
    end

    def capture_association_modification(action, object)
      process_association(action, self, object)
      process_association(action, object, self)
    end

    def process_association(action, from_object, to_object)
      if to_object.respond_to? :rabbitmq_id
        from_serializer = ActiveModel::Serializer.serializer_for(from_object)
        to_serializer = ActiveModel::Serializer.serializer_for(to_object)
        association =
          from_serializer._reflections.find do |name, params|
            params.options[:serializer] == to_serializer
          end
        case association.class.to_s
        when "ActiveModel::Serializer::HasManyReflection"
          from_object.send_rabbitmq_notification(
            :updated,
            changes = {
              association.name => { action => [to_object.rabbitmq_id] }
            },
          )
        when "ActiveModel::Serializer::HasOneReflection"
          #ToDo
          nil
        when "ActiveModel::Serializer::BelongsToReflection"
          #ToDo
          nil
        end
      end
    end

    # This method doesn't use ActiveRecord's method "previous_changes"
    # because we need to capture changes on the serialized representation
    # of the resource.
    def capture_serialisation_changes
      serialiser = ActiveModel::Serializer.serializer_for(self)
      if self.id
        before = serialiser.new(self.clone.reload).attributes
        action = :updated
      else
        before = {}
        action = :created
      end

      GorgRabbitmqNotifier.batch do
        yield

        after = serialiser.new(self).attributes
        changes = deep_hash_diff(before, after)
        send_rabbitmq_notification(action, changes)
      end
    end

    def deep_hash_diff(a, b)
      (a.keys | b.keys).inject({}) do |diff, k|
        if a[k] != b[k]
          if a[k].respond_to?(:deep_diff) && b[k].respond_to?(:deep_diff)
            diff[k] = a[k].deep_diff(b[k])
          else
            diff[k] = [a[k], b[k]]
          end
        end
        diff
      end
    end
  end
end
