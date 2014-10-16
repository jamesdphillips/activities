module Activities
  class Activity < ActiveRecord::Base

    self.table_name = 'activities'

    #-----------------------------------------------------------------------------
    # Relationships
    #-----------------------------------------------------------------------------

    belongs_to :actor, -> { unscoped },  polymorphic: true
    belongs_to :target, -> { unscoped }, polymorphic: true
    belongs_to :obj, -> { unscoped },    polymorphic: true
    belongs_to :result, -> { unscoped }, polymorphic: true

    has_many :receivers, class_name: Activities::Receiver

    #-----------------------------------------------------------------------------
    # Instance Methods
    #-----------------------------------------------------------------------------

    def actor
      actor_value || load_association(:actor)
    end

    def target
      target_value || load_association(:target)
    end

    def obj
      obj_value || load_association(:obj)
    end

    def result
      result_value || load_association(:result)
    end

    private

    def load_association(type)
      association(type).send(:target_id) && association(type).send(:find_target)
    end

  end
end
