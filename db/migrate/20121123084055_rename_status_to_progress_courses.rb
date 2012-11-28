class RenameStatusToProgressCourses < ActiveRecord::Migration
  def change
    rename_column :courses, :status, :progress
  end
end
