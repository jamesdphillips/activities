module Activities
  class Query

    DEFAULT_COUNT = 10

    def initialize(receiver)
      @receiver = receiver
    end

    def query(cursor = nil, count = DEFAULT_COUNT)
      #AR or redis
      receiver_activities = activities_query
      activities = begin
        if cursor
          if cursor >= 0
            next_cursored_activities(receiver_activities, cursor, count)
          else
            if cursor == -1
              first_activities(receiver_activities, count)
            else
               prev_cursored_activities(receiver_activities, -cursor, count)
            end
          end
        else
          first_activities(receiver_activities, count)
        end
      end

      p_cursor = (activities.any? ? prev_cursor(receiver_activities, activities.first) : 0)
      n_cursor = (activities.any? ? next_cursor(receiver_activities, activities.last) : 0)
      [activities, p_cursor, n_cursor]
    end

    def delete_by_id(activity_id)
      delete_activity_query(activity_id)
    end

    def cursor(activity)
      time_to_timestamp(activity.created_at)
    end

    # Converts AR Time to milliseconds since epoch to use as cursor
    def time_to_timestamp(time)
      (time.to_f * 1000).to_i
    end

    # Converts milliseconds since epoch to Time for AR query
    def timestamp_to_time(cursor)
      Time.at(cursor.to_i / 1000.0)
    end

    private

    def prev_cursor(receiver_activities, activity)
      if receiver_activities.where("created_at > ?", activity.created_at).any?
        -cursor(activity)
      else
        0
      end
    end

    def next_cursor(receiver_activities, activity)
      if receiver_activities.where("created_at < ?", activity.created_at).any?
        cursor(activity)
      else
        0
      end
    end

    def first_activities(receiver_activities, count)
      limited_activities(receiver_activities, count)
    end

    def prev_cursored_activities(receiver_activities, cursor, count)
      activities = prev_activities(receiver_activities, cursor)
      reverse_limited_activities(activities, count)
    end

    def prev_activities(activities, cursor)
      activities.where("created_at >= ?", timestamp_to_time(cursor))
    end

    def next_cursored_activities(receiver_activities, cursor, count)
      activities = next_activities(receiver_activities, cursor)
      limited_activities(activities, count)
    end

    def next_activities(activities, cursor)
      activities.where("created_at <= ?", timestamp_to_time(cursor))
    end

    def activities_query
      klass = @receiver.class.base_class.name
      Activity
        .joins("JOIN activity_receivers ON activity_receivers.activity_id = activities.id")
        .where("activity_receivers.receiver_type = ? AND activity_receivers.receiver_id = ?", klass, @receiver.id)
        .order(created_at: :desc)
    end

    def delete_activity_query(activity_id)
      Activity
        .destroy(activity_id)
    end

    # Activity.joins("JOIN activity_receivers ON activity_receivers.activity_id = activities.id").where("activity_receivers.receiver_type = ? AND activity_receivers.receiver_id = ?", 'Organization', 2).order(created_at: :desc)

    def limited_activities(activities, count)
      activities.limit(count)
    end

    def reverse_limited_activities(activities, count)
      activities.last(count)
    end
  end
end
