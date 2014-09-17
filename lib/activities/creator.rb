module Activities
  class Creator #TODO: make active model?
    include ActiveModel::Validations

    ValidationError = Class.new(StandardError)

    #-----------------------------------------------------------------------------
    # Class Methods
    #-----------------------------------------------------------------------------

    class << self
      def message(value)
        @message = value
      end
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def create

      activity = ActiveRecord::Base.transaction do
        # TODO do something with message

        activity_id = SecureRandom.uuid
        receivers = @attributes.delete(:receivers)

        actor_name = @attributes.delete(:actor_name)
        title_objects = @attributes.delete(:title_objects)
        title = create_title(actor_name, @attributes[:verb], title_objects)

        activity = create_activity(@attributes.merge(id: activity_id, title: title))

        receivers.each do |receiver|
          create_activity_receiver(activity_id: activity_id, receiver: receiver)
        end

        activity
      end


      # TODO add to redis

      # TODO dispatch notifications for delivery

      # TODO better method name?
      activity
    end

    private

    def create_activity(attributes)
      Activities::Activity.create!(attributes)
    end

    def create_activity_receiver(attributes)
      Activities::Receiver.create!(attributes)
    end

    def create_title(actor_name, verb, title_objects)
      i18n_key = I18n.t("activities.#{verb}", title_objects)
      "#{actor_name} #{i18n_key}"
    end

  end
end
