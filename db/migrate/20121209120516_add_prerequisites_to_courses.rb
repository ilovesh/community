class AddPrerequisitesToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :prerequisites, :text
  end
end
