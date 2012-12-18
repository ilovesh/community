class ChangeDateFormatInCourses < ActiveRecord::Migration
  def change
    change_column :courses, :start_date, :datetime
    change_column :courses, :final_date, :datetime
  end
end
