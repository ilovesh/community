class AddCourseUrlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_url, :string
  end
end
