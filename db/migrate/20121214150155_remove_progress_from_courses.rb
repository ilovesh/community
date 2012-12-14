class RemoveProgressFromCourses < ActiveRecord::Migration
  def up
    remove_column :courses, :progress
  end

  def down
    add_column :courses, :progress, :integer
  end
end
