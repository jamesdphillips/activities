# Activities

Gem for creating and querying an activity feed. Activities can be scoped to any object.

## Installation

Add this line to your application's Gemfile:

    gem 'activities'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activities

## Setup

Use the generator to set up the initializer and migration

`rails generate activities:install foo` will generate:

```
#initializers/activities.rb
Activities.configure do
  verb :add_user do
  end
end

# db/migrate/<timestamp>_create_activities.rb
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
      t.datetime  :created_at
      t.datetime  :updated_at
      t.json      :data
      t.string    :scope
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

```

Add verbs to be used for activity creation in `initializers/activities.rb`
```
Activities.configure do
  verb :verb_name do
  end
end
```

Add an entry for each verb to the translations file `locales/en.yml`
```
en:
  activities:
    verb_name: "added the record %{record_name} at location %{record_location}"
```

## Usage

### Activity Creation

Add verbs to be used for activity creation in `initializers/activities.rb`

To create a new activity, in your app call the following (note the bang), where 'verb_name' is one of your verbs defined in the activities initializer.

```
Activities.verb_name!({
  actor: user,
  actor_name: "#{user.first_name} #{user.last_name}",
  obj: record,
  target: record.location,
  receivers: [user, organization, record],
  title_objects: {record_name: record.name, record_location: record.location.name}})
```
`actor` is the user that performed the action

`obj` is the subject of the action

`result` is the result of the action

`target` is the location of the obj

`receivers` enumerates who can be informed of the action.

`title_objects` is a hash that includes any variables in the i18n translation for the verb

The activity's title field will be generated using the actor_name, I18n entry, and title_objects.

### Activity Querying

Activity queries are performed on a receiver, and can be cursored with a previous and next, as well as limited to a specific count.

```
receiver = current_user
activities, prev_cursor, next_cursor = Activities::Query.new(receiver).query(cursor, count)
```
Cursors are formatted as milliseconds since epoch.

The general premise is taken from: https://dev.twitter.com/overview/api/cursoring

A negative value for the cursor indicates a look forward query for newer activities. prev_cursor will be a negative value (unless 0).

Querying with a cursor of -1 performs an initial query of the most recent activities for the receiver.

A prev_cursor of 0 indicates there are no newer activites to query for.

A next_cursor of 0 indicates there are no older activites to query for.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/activities/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
