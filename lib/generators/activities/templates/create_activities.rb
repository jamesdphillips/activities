class CreateActivities < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :activities, id: :uuid do |t|
      t.integer   :actor_id
      t.string    :actor_type
      t.string    :actor_value
      t.integer   :target_id
      t.string    :target_type
      t.string    :target_value
      t.integer   :result_id
      t.string    :result_type
      t.string    :result_value
      t.integer   :obj_id
      t.string    :obj_type
      t.string    :obj_value
      t.text      :title
      t.string    :verb
      t.json      :data
      t.string    :scope
      t.timestamps
    end

    create_table :activity_receivers do |t|
      t.uuid    :activity_id
      t.integer :receiver_id
      t.string  :receiver_type
      t.json    :states
    end

    add_index :activity_receivers, :activity_id
    add_index :activity_receivers, [:receiver_id, :receiver_type]
  end
end
