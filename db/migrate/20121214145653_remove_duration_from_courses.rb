class RemoveDurationFromCourses < ActiveRecord::Migration
  def up
    remove_column :courses, :duration
  end

  def down
    add_column :courses, :duration, :integer
  end
end
