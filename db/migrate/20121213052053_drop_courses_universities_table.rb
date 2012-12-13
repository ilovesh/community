class DropCoursesUniversitiesTable < ActiveRecord::Migration
  def up
    drop_table :courses_universities
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
