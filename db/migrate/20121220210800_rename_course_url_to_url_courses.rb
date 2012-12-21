class RenameCourseUrlToUrlCourses < ActiveRecord::Migration
  def change
    rename_column :courses, :course_url, :url
  end
end
