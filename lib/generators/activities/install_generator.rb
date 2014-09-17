require "rails/generators/active_record"

class Activities::InstallGenerator < ActiveRecord::Generators::Base
  # < Rails::Generators::Base
  # include Rails::Generators::Migration

  source_root File.expand_path("../templates", __FILE__)
  desc "Installs Activities"

  def install
    template "initializer.rb", "config/initializers/activities.rb"

    migration_template "create_activities.rb", "db/migrate/create_activities.rb"
  end
end
