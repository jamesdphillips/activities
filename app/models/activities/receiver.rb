module Activities
  class Receiver < ActiveRecord::Base

    self.table_name = 'activity_receivers'

    belongs_to :activity, class_name: Activities::Activity
    belongs_to :receiver, polymorphic: true

  end
end
