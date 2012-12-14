class DropCoursesUniversitiesTable < ActiveRecord::Migration
  def change
    drop_table :courses_universities
  end
end
