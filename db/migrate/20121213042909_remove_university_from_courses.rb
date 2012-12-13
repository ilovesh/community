class RemoveUniversityFromCourses < ActiveRecord::Migration
  def up
    remove_column :courses, :university
  end

  def down
    add_column :courses, :university, :string
  end
end
